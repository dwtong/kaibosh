defmodule KaiboshWeb.AuthenticationTest do
  use KaiboshWeb.ConnCase
  alias Kaibosh.Accounts.UserSession
  alias KaiboshWeb.Authentication

  describe "set_auth_header/2" do
    test "sets user id as authentication token", %{conn: conn} do
      id = 999
      conn = Authentication.set_auth_header(conn, id)

      assert ["Bearer " <> token] = get_resp_header(conn, "authorization")
      assert {:ok, decoded_token} = Authentication.verify_token(token)
      assert decoded_token == id
    end
  end

  describe "set_session_cookie/2" do
    test "sets user session token as cookie", %{conn: conn} do
      token = "76530d20-cc85-4745-a7d6-523e3a89971d"
      conn = Authentication.set_session_cookie(conn, token)

      assert %{cookies: %{"_kaibosh_token" => encoded_token}} = fetch_cookies(conn)
      assert {:ok, decoded_token} = Authentication.verify_token(encoded_token)
      assert decoded_token == token
    end
  end

  describe "destroy_session/1" do
    test "destroys user session cookie and deletes user session", %{conn: conn} do
      user_session = insert(:user_session)
      conn = Authentication.set_session_cookie(conn, user_session.token)

      assert %{cookies: %{"_kaibosh_token" => encoded_token}} = fetch_cookies(conn)

      conn = Authentication.destroy_session(conn)
      assert fetch_cookies(conn).cookies == %{}
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(UserSession, user_session.id) end
    end
  end
end
