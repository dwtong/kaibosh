defmodule Kaibosh.RecipientSessionsTest do
  use Kaibosh.DataCase

  alias Kaibosh.RecipientSessions

  describe "recipient_sessions" do
    alias Kaibosh.RecipientSessions.RecipientSession

    @invalid_attrs %{session_id: nil}

    test "list_recipient_sessions/0 returns all recipient_sessions" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      assert RecipientSessions.list_recipient_sessions() == [recipient_session]
    end

    test "get_recipient_session!/1 returns the recipient_session with given id" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      assert RecipientSessions.get_recipient_session!(recipient_session.id) == recipient_session
    end

    test "create_recipient_session/1 with valid data creates a recipient_session" do
      session = insert(:session)
      recipient = insert(:recipient)
      attrs = %{session_id: session.id, recipient_id: recipient.id}

      assert {:ok, %RecipientSession{} = recipient_session} =
               RecipientSessions.create_recipient_session(attrs)

      assert recipient_session.session_id == session.id
      assert recipient_session.recipient_id == recipient.id
    end

    test "create_recipient_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               RecipientSessions.create_recipient_session(@invalid_attrs)
    end

    test "update_recipient_session/2 with valid data updates the recipient_session" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      new_session = insert(:session)
      attrs = %{session_id: new_session.id}

      assert {:ok, %RecipientSession{} = recipient_session} =
               RecipientSessions.update_recipient_session(recipient_session, attrs)

      assert recipient_session.session_id == new_session.id
    end

    test "update_recipient_session/2 with invalid data returns error changeset" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])

      assert {:error, %Ecto.Changeset{}} =
               RecipientSessions.update_recipient_session(recipient_session, @invalid_attrs)

      assert recipient_session == RecipientSessions.get_recipient_session!(recipient_session.id)
    end

    test "delete_recipient_session/1 deletes the recipient_session" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])

      assert {:ok, %RecipientSession{}} =
               RecipientSessions.delete_recipient_session(recipient_session)

      assert_raise Ecto.NoResultsError, fn ->
        RecipientSessions.get_recipient_session!(recipient_session.id)
      end
    end

    test "change_recipient_session/1 returns a recipient_session changeset" do
      recipient_session = insert(:recipient_session) |> Repo.forget([:recipient, :session])
      assert %Ecto.Changeset{} = RecipientSessions.change_recipient_session(recipient_session)
    end
  end

  describe "holds" do
    alias Kaibosh.RecipientSessions.Hold

    @valid_attrs %{ends_at: ~U[2010-04-17 14:00:00Z], starts_at: ~U[2010-04-17 14:00:00Z]}
    @update_attrs %{ends_at: ~U[2011-05-18 15:01:01Z], starts_at: ~U[2011-05-18 15:01:01Z]}
    @invalid_attrs %{ends_at: nil, starts_at: nil}

    test "list_holds/0 returns all holds" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert RecipientSessions.list_holds() == [hold]
    end

    test "get_hold!/1 returns the hold with given id" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert RecipientSessions.get_hold!(hold.id) == hold
    end

    test "create_hold/1 with valid data creates a hold" do
      recipient_session = insert(:recipient_session)
      attrs = Map.put(@valid_attrs, :recipient_session_id, recipient_session.id)
      assert {:ok, %Hold{} = hold} = RecipientSessions.create_hold(attrs)
      assert hold.ends_at == ~U[2010-04-17 14:00:00Z]
      assert hold.starts_at == ~U[2010-04-17 14:00:00Z]
    end

    test "create_hold/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipientSessions.create_hold(@invalid_attrs)
    end

    test "update_hold/2 with valid data updates the hold" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert {:ok, %Hold{} = hold} = RecipientSessions.update_hold(hold, @update_attrs)
      assert hold.ends_at == ~U[2011-05-18 15:01:01Z]
      assert hold.starts_at == ~U[2011-05-18 15:01:01Z]
    end

    test "update_hold/2 with invalid data returns error changeset" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert {:error, %Ecto.Changeset{}} = RecipientSessions.update_hold(hold, @invalid_attrs)
      assert hold == RecipientSessions.get_hold!(hold.id)
    end

    test "delete_hold/1 deletes the hold" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert {:ok, %Hold{}} = RecipientSessions.delete_hold(hold)
      assert_raise Ecto.NoResultsError, fn -> RecipientSessions.get_hold!(hold.id) end
    end

    test "change_hold/1 returns a hold changeset" do
      hold = insert(:hold) |> Repo.forget(:recipient_session)
      assert %Ecto.Changeset{} = RecipientSessions.change_hold(hold)
    end
  end

  describe "allocations" do
    alias Kaibosh.RecipientSessions.Allocation

    @valid_attrs %{quantity: "120.5"}
    @update_attrs %{quantity: "456.7"}
    @invalid_attrs %{recipient_session_id: nil}

    test "list_allocations/0 returns all allocations" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])
      assert RecipientSessions.list_allocations() == [allocation]
    end

    test "get_allocation!/1 returns the allocation with given id" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])
      assert RecipientSessions.get_allocation!(allocation.id) == allocation
    end

    test "create_allocation/1 with valid data creates a allocation" do
      allocation_category = insert(:allocation_category, id: 999)
      recipient_session = insert(:recipient_session, id: 999)

      attrs =
        Map.merge(@valid_attrs, %{
          allocation_category_id: allocation_category.id,
          recipient_session_id: recipient_session.id
        })

      assert {:ok, %Allocation{} = allocation} = RecipientSessions.create_allocation(attrs)
      assert allocation.quantity == Decimal.new("120.5")
      assert allocation.allocation_category_id == allocation_category.id
      assert allocation.recipient_session_id == recipient_session.id
    end

    test "create_allocation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RecipientSessions.create_allocation(@invalid_attrs)
    end

    test "update_allocation/2 with valid data updates the allocation" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])

      assert {:ok, %Allocation{} = allocation} =
               RecipientSessions.update_allocation(allocation, @update_attrs)

      assert allocation.quantity == Decimal.new("456.7")
    end

    test "update_allocation/2 with invalid data returns error changeset" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])

      assert {:error, %Ecto.Changeset{}} =
               RecipientSessions.update_allocation(allocation, @invalid_attrs)

      assert allocation == RecipientSessions.get_allocation!(allocation.id)
    end

    test "delete_allocation/1 deletes the allocation" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])
      assert {:ok, %Allocation{}} = RecipientSessions.delete_allocation(allocation)
      assert_raise Ecto.NoResultsError, fn -> RecipientSessions.get_allocation!(allocation.id) end
    end

    test "change_allocation/1 returns a allocation changeset" do
      allocation = insert(:allocation) |> Repo.forget([:allocation_category, :recipient_session])
      assert %Ecto.Changeset{} = RecipientSessions.change_allocation(allocation)
    end
  end
end
