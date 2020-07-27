defmodule KaiboshWeb.Authentication do
  @moduledoc """
  A collection of functions for generating and fetching
  authentication tokens and cookies.

  Authorization tokens live in authorization header and are short-lived,
  session tokens are stored in session and DB.
  """
  import Plug.Conn
  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.UserSession
  alias KaiboshWeb.Endpoint

  @salt "access token"
  @five_minutes 300

  def generate_token(session, max_age) do
    Phoenix.Token.sign(Endpoint, @salt, session, max_age: max_age)
  end

  def verify_token(nil), do: {:error, :token_not_present}

  def verify_token(token) do
    Phoenix.Token.verify(Endpoint, @salt, token)
  end

  def create_session(conn, %UserSession{user_id: user_id, token: token}) do
    conn
    |> fetch_session()
    |> put_session(:token, token)
    |> put_session(:user_id, user_id)
    |> set_auth_header(user_id)
  end

  def destroy_session(conn) do
    conn = fetch_session(conn)

    conn
    |> fetch_session()
    |> get_session(:token)
    |> case do
      nil -> nil
      token -> Accounts.sign_out(token)
    end

    clear_session(conn)
  end

  def set_auth_header(conn, user_id, max_age \\ @five_minutes) do
    user_id
    |> generate_token(max_age)
    |> (&put_resp_header(conn, "authorization", "Bearer #{&1}")).()
  end

  def fetch_auth_header_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end
end
