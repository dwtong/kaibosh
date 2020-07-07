defmodule Kaibosh.Accounts.AccountsTest do
  use Kaibosh.DataCase
  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User
  alias Kaibosh.Accounts.UserSession

  describe "managing users" do
    @valid_attrs %{email: "some email", password: "some password"}
    @update_attrs %{email: "some updated email", password: "some updated password"}
    @invalid_attrs %{email: nil, password: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "sign in and sign out" do
    test "signs in creates session token for valid user" do
      email = "foo@bar.com"
      password = "pa55word"

      assert {:ok, %User{} = user} = Accounts.create_user(%{email: email, password: password})
      assert {:ok, %UserSession{} = session} = Accounts.sign_in(email, password)
      assert session.user_id == user.id
      assert !is_nil(session.token)
    end

    test "does not sign in for invalid user" do
      email = "invalid@bar.com"
      password = "pa55word"

      assert {:error, :invalid_user} = Accounts.sign_in(email, password)
    end

    test "deletes user session on sign out" do
      session = insert(:user_session)
      assert {1, nil} = Accounts.sign_out(session.token)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(UserSession, session.id) end
    end

    test "fetches session if session token exists for user" do
      session = insert(:user_session)
      assert Accounts.get_user_session(session.token)
    end

    test "does not fetch non existent user session" do
      fake_token = "808b16f6-aa25-4a13-8003-4214ca2335e5"
      refute Accounts.get_user_session(fake_token)
    end
  end
end
