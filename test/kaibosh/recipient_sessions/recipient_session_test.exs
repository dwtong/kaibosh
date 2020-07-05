defmodule Kaibosh.RecipientSessions.RecipientSessionTest do
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
end
