defmodule KaiboshWeb.AuthenticationTest do
  use KaiboshWeb.ConnCase
  alias Kaibosh.Accounts.UserSession
  alias KaiboshWeb.Authentication

  describe "creating session" do
    setup [:create_user_session, :setup_conn]

    test "sets user id as authentication token", %{conn: conn, user_session: user_session} do
      conn = Authentication.create_session(conn, user_session)

      assert ["Bearer " <> token] = get_resp_header(conn, "authorization")
      assert {:ok, decoded_token} = Authentication.verify_token(token)
      assert decoded_token == user_session.user_id
    end

    test "sets user session token as cookie", %{conn: conn, user_session: user_session} do
      conn = Authentication.create_session(conn, user_session) |> fetch_session()

      assert get_session(conn, :user_id) == user_session.user_id
      assert get_session(conn, :token) == user_session.token
    end
  end

  describe "destroying session" do
    setup [:create_user_session, :setup_conn]

    test "destroys user session, cookie and deletes user session", %{
      conn: conn,
      user_session: user_session
    } do
      conn = Authentication.create_session(conn, user_session) |> fetch_session()

      assert get_session(conn, :user_id) == user_session.user_id
      assert get_session(conn, :token) == user_session.token

      conn = Authentication.destroy_session(conn) |> fetch_session()

      assert is_nil(get_session(conn, :user_id))
      assert is_nil(get_session(conn, :token))

      assert_raise Ecto.NoResultsError, fn -> Repo.get!(UserSession, user_session.id) end
    end
  end

  defp create_user_session(_) do
    %{user_session: insert(:user_session)}
  end

  defp setup_conn(%{conn: conn}) do
    %{conn: init_test_session(conn, %{})}
  end
end
