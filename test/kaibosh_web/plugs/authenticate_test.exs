defmodule KaiboshWeb.Plugs.AuthenticateTest do
  use KaiboshWeb.ConnCase
  alias KaiboshWeb.Authentication
  alias KaiboshWeb.Plugs.Authenticate

  setup do
    session = insert(:user_session)
    conn = build_conn() |> Plug.Conn.put_req_header("accept", "application/json")
    %{session: session, conn: conn}
  end

  describe "unauthorized users" do
    test "return 401 when bearer token is not set", %{conn: conn} do
      conn = conn |> authenticate()
      assert not_authorized?(conn)
    end

    test "return 401 when bearer token is invalid", %{conn: conn} do
      conn = conn |> put_invalid_token() |> authenticate()
      assert not_authorized?(conn)
    end

    test "return 401 when session cookie is not set", %{conn: conn, session: session} do
      conn = conn |> put_valid_token(session) |> authenticate()
      assert not_authorized?(conn)
    end

    test "return 401 when session cookie has expired", %{conn: conn, session: session} do
      conn = conn |> put_expired_token(session) |> put_expired_cookie(session) |> authenticate()
      assert not_authorized?(conn)
    end

    test "return 401 when session does not exist in db", %{conn: conn, session: session} do
      Repo.delete!(session)
      conn = conn |> put_expired_token(session) |> put_valid_cookie(session) |> authenticate()

      assert not_authorized?(conn)
    end
  end

  describe "authorized users" do
    test "bearer token is reused if it is valid and not expired", %{conn: conn, session: session} do
      conn = conn |> put_valid_token(session) |> put_valid_cookie(session) |> authenticate()

      assert authorized?(conn)
      assert !is_nil(resp_auth_token(conn))
      assert req_auth_token(conn) == resp_auth_token(conn)
    end

    test "session token and cookie are regenerated if bearer has expired and session is valid", %{
      conn: conn,
      session: session
    } do
      conn = conn |> put_expired_token(session) |> put_valid_cookie(session) |> authenticate()

      assert authorized?(conn)
      assert !is_nil(resp_auth_token(conn))
      assert req_auth_token(conn) != resp_auth_token(conn)
      assert !is_nil(resp_session_cookie(conn))
      assert req_session_cookie(conn) != resp_session_cookie(conn)
    end
  end

  defp put_invalid_token(conn) do
    token = "Bearer SFMyNTY.g2gDYQFuBgB-lE46cwFhAQ.POhp0mC-6hU4WaTzlyFdAYRM72qrQ9ospfR3WZwlPU0"
    conn |> put_req_header("authorization", token)
  end

  defp put_valid_token(conn, %{user_id: user_id}, max_age \\ 5000) do
    token = Authentication.generate_token(user_id, max_age)
    conn |> put_req_header("authorization", "Bearer #{token}")
  end

  defp put_valid_cookie(conn, %{token: token}, max_age \\ 5000) do
    token = Authentication.generate_token(token, max_age)
    put_req_cookie(conn, "_kaibosh_token", token)
  end

  defp put_expired_token(conn, session) do
    conn |> put_valid_token(session, 0)
  end

  defp put_expired_cookie(conn, session) do
    conn |> put_valid_cookie(session, 0)
  end

  defp req_auth_token(conn) do
    ["Bearer " <> token] = get_req_header(conn, "authorization")
    token
  end

  defp resp_auth_token(conn) do
    ["Bearer " <> token] = get_resp_header(conn, "authorization")
    token
  end

  defp req_session_cookie(conn) do
    %{req_cookies: %{"_kaibosh_token" => token}} = fetch_cookies(conn)
    token
  end

  defp resp_session_cookie(conn) do
    %{resp_cookies: %{"_kaibosh_token" => %{value: token}}} = conn
    token
  end

  defp authenticate(conn) do
    conn |> Authenticate.call(%{})
  end

  defp not_authorized?(conn) do
    conn.status == 401
  end

  defp authorized?(conn) do
    conn.status != 401
  end
end
