defmodule KaiboshWeb.UserControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Accounts.User

  @create_attrs %{email: "test@test.com"}
  @invalid_attrs %{email: nil}

  describe "list users" do
    setup [:create_user]

    test "lists users with the correct attrs", %{conn: conn, user: expected_user} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert [user] = json_response(conn, 200)
      assert Map.keys(user) == ~w(email)

      assert user["email"] == expected_user.email
    end
  end

  describe "create user" do
    test "creates user with generated password when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{"email" => email} = json_response(conn, 201)
      assert %User{} = user = Repo.get_by(User, email: email)
      assert user.email == @create_attrs.email
      assert !is_nil(user.password_hash)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    %{user: insert(:user)}
  end
end
