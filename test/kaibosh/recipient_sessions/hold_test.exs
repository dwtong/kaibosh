defmodule Kaibosh.RecipientSessions.HoldTest do
  use Kaibosh.DataCase

  alias Kaibosh.RecipientSessions

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
end
