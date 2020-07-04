defmodule Kaibosh.SessionsTest do
  use Kaibosh.DataCase

  alias Kaibosh.Sessions

  describe "sessions" do
    alias Kaibosh.Sessions.Session

    @valid_attrs %{day: "some day", time_in_seconds: 42}
    @update_attrs %{day: "some updated day", time_in_seconds: 43}
    @invalid_attrs %{day: nil, time_in_seconds: nil}

    test "list_sessions/0 returns all sessions" do
      session = insert(:session) |> Repo.forget(:base)
      assert Sessions.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = insert(:session) |> Repo.forget(:base)
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)
      assert {:ok, %Session{} = session} = Sessions.create_session(attrs)
      assert session.day == "some day"
      assert session.time_in_seconds == 42
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:ok, %Session{} = session} = Sessions.update_session(session, @update_attrs)
      assert session.day == "some updated day"
      assert session.time_in_seconds == 43
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = insert(:session) |> Repo.forget(:base)
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end
end
