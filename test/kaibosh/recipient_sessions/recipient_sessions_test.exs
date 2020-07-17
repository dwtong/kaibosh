defmodule Kaibosh.RecipientSessionsTest do
  use Kaibosh.DataCase

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.Allocation
  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession

  @invalid_attrs %{session_id: nil}

  describe "getting and listing recipient sessions" do
    setup [:create_recipient_session_with_associations]

    test "listing sessions returns all recipient's sessions", %{recipient_id: recipient_id} do
      sessions = RecipientSessions.list_sessions_for_recipient(recipient_id)
      assert [%RecipientSession{} = session] = sessions
      assert length(session.allocations) == 1
      assert length(session.holds) == 1
    end

    test "listing sessions does not return other sessions", %{recipient_id: recipient_id} do
      %{id: other_session_id} = insert(:recipient_session)
      sessions = RecipientSessions.list_sessions_for_recipient(recipient_id)
      assert length(sessions) == 1
      refute Enum.any?(sessions, &(&1.id == other_session_id))
    end

    test "get_session!/1 returns the session with given id", %{recipient_session: %{id: id}} do
      assert %RecipientSession{} = session = RecipientSessions.get_session!(id)
      assert length(session.allocations) == 1
      assert length(session.holds) == 1
    end
  end

  describe "creating recipient sessions and allocations" do
    setup [:create_session, :create_recipient]

    test "create_session/1 with valid data creates session", %{
      session: session,
      recipient: recipient
    } do
      attrs = %{session_id: session.id, recipient_id: recipient.id}

      assert {:ok, %RecipientSession{} = recipient_session} =
               RecipientSessions.create_session(attrs)

      assert recipient_session.session_id == session.id
      assert recipient_session.recipient_id == recipient.id
    end

    test "create_session/1 with allocations creates allocations and recipient session" do
      session = insert(:session)
      recipient = insert(:recipient)
      category = insert(:category)
      a1 = %{category_id: category.id, quantity: 0.5}
      a2 = %{category_id: category.id, quantity: 2.0}
      attrs = %{session_id: session.id, recipient_id: recipient.id, allocations: [a1, a2]}

      assert {:ok, %RecipientSession{allocations: allocations}} =
               RecipientSessions.create_session(attrs)

      assert length(allocations) == 2
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a1.quantity)))
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a2.quantity)))
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipientSessions.create_session(@invalid_attrs)
    end
  end

  describe "modifying recipient sessions and allocations" do
    test "update_session/2 with valid data updates the recipient_session" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      new_session = insert(:session)
      attrs = %{session_id: new_session.id}

      assert {:ok, %RecipientSession{} = recipient_session} =
               RecipientSessions.update_session(recipient_session, attrs)

      assert recipient_session.session_id == new_session.id
    end

    test "update_session/2 creates new allocations" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      category = insert(:category)
      a1 = %{category_id: category.id, quantity: 0.5}
      a2 = %{category_id: category.id, quantity: 2.0}
      attrs = %{allocations: [a1, a2]}

      assert {:ok, %RecipientSession{allocations: allocations}} =
               RecipientSessions.update_session(recipient_session, attrs)

      assert length(allocations) == 2
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a1.quantity)))
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a2.quantity)))
    end

    test "update_session/2 updates existing allocations that have been modified" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      category = insert(:category)
      a1 = insert(:allocation, category: category, recipient_session: recipient_session)
      a1_updated = %{id: a1.id, category_id: category.id, quantity: 5.5}
      attrs = %{allocations: [a1_updated]}

      assert {:ok, %RecipientSession{allocations: allocations}} =
               RecipientSessions.update_session(recipient_session, attrs)

      assert length(allocations) == 1
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a1_updated.quantity)))
    end

    test "update_session/2 deletes existing allocations when they are not provided" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      category = insert(:category)
      insert(:allocation, category: category, recipient_session: recipient_session)
      a2 = insert(:allocation, category: category, recipient_session: recipient_session)

      a2_keep = %{id: a2.id, category_id: category.id, quantity: 2.0}
      attrs = %{allocations: [a2_keep]}

      assert {:ok, %RecipientSession{allocations: allocations}} =
               RecipientSessions.update_session(recipient_session, attrs)

      assert length(allocations) == 1
      assert Enum.any?(allocations, &(&1.quantity == Decimal.cast(a2_keep.quantity)))
    end

    test "update_session/2 does not delete existing allocations when field is not set" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      category = insert(:category)
      insert(:allocation, category: category, recipient_session: recipient_session)
      insert(:allocation, category: category, recipient_session: recipient_session)
      attrs = %{holds: []}

      assert {:ok, %RecipientSession{allocations: allocations}} =
               RecipientSessions.update_session(recipient_session, attrs)

      assert length(allocations) == 2
    end

    test "update_session/2 with invalid data returns error changeset" do
      recipient_session =
        insert(:recipient_session)
        |> Repo.forget([:recipient])
        |> Repo.preload([:allocations, :holds])

      assert {:error, %Ecto.Changeset{}} =
               RecipientSessions.update_session(recipient_session, @invalid_attrs)

      assert recipient_session.session_id ==
               RecipientSessions.get_session!(recipient_session.id).session_id
    end

    test "delete_session/1 deletes the recipient_session and associations" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      allocation = insert(:allocation, recipient_session: recipient_session)
      hold = insert(:hold, recipient_session: recipient_session)

      assert {:ok, %RecipientSession{}} = RecipientSessions.delete_session(recipient_session)

      assert_raise Ecto.NoResultsError, fn ->
        RecipientSessions.get_session!(recipient_session.id)
      end

      refute Repo.get(Allocation, allocation.id)
      refute Repo.get(Hold, hold.id)
    end

    test "change_session/1 returns a recipient_session changeset" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      assert %Ecto.Changeset{} = RecipientSessions.change_session(recipient_session)
    end
  end

  describe "creating and deleting session holds" do
    @valid_attrs %{
      ends_at: ~U[2010-04-17 14:00:00.000000Z],
      starts_at: ~U[2010-04-17 14:00:00.000000Z]
    }
    @invalid_attrs %{ends_at: nil, starts_at: nil}

    test "create_hold/1 with valid data creates a hold" do
      recipient_session = insert(:recipient_session)
      attrs = Map.put(@valid_attrs, :recipient_session_id, recipient_session.id)
      assert {:ok, %Hold{} = hold} = RecipientSessions.create_hold(attrs)
      assert hold.ends_at == ~U[2010-04-17 14:00:00.000000Z]
      assert hold.starts_at == ~U[2010-04-17 14:00:00.000000Z]

      assert RecipientSessions.get_hold_for_recipient!(
               hold.id,
               recipient_session.recipient_id
             ) == hold
    end

    test "create_hold/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipientSessions.create_hold(@invalid_attrs)
    end

    test "delete_hold/1 deletes the hold" do
      hold = insert(:hold)
      assert {:ok, %Hold{}} = RecipientSessions.delete_hold(hold)

      assert_raise Ecto.NoResultsError, fn ->
        RecipientSessions.get_hold_for_recipient!(hold.id, hold.recipient_session.recipient_id)
      end
    end
  end

  defp create_session(_) do
    %{session: insert(:session)}
  end

  defp create_recipient(_) do
    %{recipient: insert(:recipient)}
  end

  defp create_recipient_session_with_associations(_) do
    recipient_session =
      insert(:recipient_session)
      |> Repo.forget([:recipient, :session])

    insert(:hold, recipient_session: recipient_session)
    |> Repo.forget(:recipient_session)

    insert(:allocation, recipient_session: recipient_session)
    |> Repo.forget(:recipient_session)

    expected_session =
      Repo.get(RecipientSession, recipient_session.id) |> Repo.preload([:allocations, :holds])

    %{recipient_session: expected_session, recipient_id: recipient_session.recipient_id}
  end
end
