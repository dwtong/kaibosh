defmodule KaiboshWeb.Authentication do
  alias KaiboshWeb.Endpoint
  alias Kaibosh.Accounts
  import Plug.Conn

  @salt "access token"
  @five_minutes 300
  @one_week 604_800

  def generate_token(session, max_age) do
    Phoenix.Token.sign(Endpoint, @salt, session, max_age: max_age)
  end

  def verify_token(nil), do: {:error, :token_not_present}

  def verify_token(token) do
    Phoenix.Token.verify(Endpoint, @salt, token)
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

  def set_session_cookie(conn, decoded_token, max_age \\ @one_week) do
    decoded_token
    |> generate_token(max_age)
    |> (&put_resp_cookie(conn, "_kaibosh_token", &1, http_only: true, max_age: max_age)).()
  end

  def fetch_session_cookie_token(conn) do
    case fetch_cookies(conn) do
      %{cookies: %{"_kaibosh_token" => encoded_token}} -> encoded_token
      _ -> nil
    end
  end

  def destroy_session(conn) do
    conn
    |> fetch_cookies()
    |> decode_session_token()
    |> sign_out_user()
    |> delete_resp_cookie("_kaibosh_token")
  end

  defp decode_session_token(%{cookies: %{"_kaibosh_token" => encoded_token}} = conn) do
    {conn, verify_token(encoded_token)}
  end

  defp sign_out_user({conn, {:ok, token}}) when is_binary(token) do
    Accounts.sign_out(token)
    conn
  end
end
