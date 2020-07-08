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

  def verify_token(token) do
    Phoenix.Token.verify(Endpoint, @salt, token)
  end

  def set_auth_header(conn, user_id) do
    user_id
    |> generate_token(@five_minutes)
    |> (&put_resp_header(conn, "authorization", "Bearer #{&1}")).()
  end

  def set_session_cookie(conn, decoded_token) do
    decoded_token
    |> generate_token(@one_week)
    |> (&put_resp_cookie(conn, "_kaibosh_token", &1, http_only: true, max_age: @one_week)).()
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
