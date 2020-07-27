defmodule KaiboshWeb.AuthControllerTest do
  import Ecto.Query
  use KaiboshWeb.ConnCase
  use Bamboo.Test

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User
  alias Kaibosh.Accounts.UserSession
  alias KaiboshWeb.Password

  setup do
    {:ok, user} = Accounts.create_user(%{email: "test@test.com", password: "pa55word"})

    conn =
      build_conn()
      |> init_test_session(%{})

    {:ok, user: user, conn: conn}
  end

  describe "reset password" do
    setup [:create_user]

    test "sends password reset email to user", %{conn: conn, user: user} do
      conn = post(conn, Routes.auth_path(conn, :password_reset), email: user.email)

      assert json_response(conn, 201)

      assert_email_delivered_with(%{to: [nil: user.email]})
    end

    test "sends 204 response regardless of whether user exists", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :password_reset), email: "invalid@foo.bar")
      assert json_response(conn, 404)
    end
  end

  describe "update password" do
    test "updates password if token is valid for user", %{conn: conn, user: user} do
      {:ok, %{password_reset_token: token}} = Password.generate_token(user.email)

      conn =
        put(conn, Routes.auth_path(conn, :update_password),
          password: "pa55word",
          password_confirmation: "pa55word",
          token: token
        )

      updated_user = Repo.get(User, user.id)

      assert json_response(conn, 200)
      assert updated_user.password != user.password
      refute updated_user.password_reset_token
    end

    test "does not update password for invalid token", %{conn: conn} do
      conn =
        put(conn, Routes.auth_path(conn, :update_password),
          password: "pa55word",
          password_confirmation: "pa55word",
          token: "XXX"
        )

      assert response(conn, 422)
    end
  end

  describe "sign in user" do
    test "creates user session and sets headers/cookies", %{user: user, conn: conn} do
      conn =
        post(conn, Routes.auth_path(conn, :create), %{
          "email" => user.email,
          "password" => user.password
        })

      assert json_response(conn, 201)

      assert contains_cookie?(conn)
      assert user_id_set?(conn)
      assert session_exists?(user.id)
      assert auth_token_set?(conn)
    end

    test "returns not found for missing user", %{conn: conn} do
      conn =
        post(conn, Routes.auth_path(conn, :create), %{
          "email" => "foo@bar.com",
          "password" => "password"
        })

      assert json_response(conn, 404)
    end
  end

  describe "sign out user" do
    test "destroys user session and deletes cookies", %{user: user} do
      %{user_id: user_id, token: token} = insert(:user_session, user: user)

      conn = init_test_session(build_conn(), %{token: token, user_id: user_id})

      assert contains_cookie?(conn)
      assert user_id_set?(conn)
      assert session_exists?(user.id)

      conn = delete(conn, Routes.auth_path(conn, :delete))

      assert response(conn, 204)
      refute contains_cookie?(conn)
      refute user_id_set?(conn)
      refute session_exists?(user.id)
    end
  end

  defp contains_cookie?(conn) do
    conn
    |> Map.get(:private)
    |> Map.get(:plug_session)
    |> Map.get("token")
    |> is_binary()
  end

  defp user_id_set?(conn) do
    conn
    |> Map.get(:private)
    |> Map.get(:plug_session)
    |> Map.get("user_id")
    |> is_integer()
  end

  defp session_exists?(user_id) do
    UserSession
    |> where(user_id: ^user_id)
    |> Repo.exists?()
  end

  defp auth_token_set?(conn) do
    case get_resp_header(conn, "authorization") do
      ["Bearer " <> _] -> true
      _ -> false
    end
  end

  defp create_user(_) do
    %{user: insert(:user)}
  end
end
