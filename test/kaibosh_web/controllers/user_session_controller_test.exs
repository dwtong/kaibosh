defmodule KaiboshWeb.UserSessionControllerTest do
  import Ecto.Query
  use KaiboshWeb.ConnCase
  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.UserSession

  setup do
    {:ok, user} = Accounts.create_user(%{email: "test@test.com", password: "pa55word"})

    conn =
      build_conn()
      |> init_test_session(%{})

    {:ok, user: user, conn: conn}
  end

  describe "sign in user" do
    test "creates user session and sets headers/cookies", %{user: user, conn: conn} do
      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
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
        post(conn, Routes.user_session_path(conn, :create), %{
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

      conn = delete(conn, Routes.user_session_path(conn, :delete))

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
end
