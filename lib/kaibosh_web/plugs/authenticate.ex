defmodule KaiboshWeb.Plugs.Authenticate do
  @moduledoc """
  Plug for checking and refreshing user session.

  Used in association with the authentication module.

  The plug handles the logic around expiring tokens
  and refreshing tokens, whereas the authentication
  module is used for setting and generating tokens.
  """
  import Plug.Conn
  require Logger
  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.UserSession
  alias KaiboshWeb.Authentication

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = fetch_session(conn)

    with {:ok, user_id} <- verify_auth_header(conn),
         true <- user_id_matches_session?(conn, user_id) do
      reuse_auth_header(conn)
    else
      {:error, :expired} ->
        conn
        |> get_session(:token)
        |> verify_user_session(conn)

      _ ->
        unauthorized_response(conn)
    end
  end

  defp verify_auth_header(conn) do
    conn
    |> Authentication.fetch_auth_header_token()
    |> Authentication.verify_token()
  end

  defp reuse_auth_header(conn) do
    conn
    |> Authentication.fetch_auth_header_token()
    |> (&put_resp_header(conn, "authorization", "Bearer #{&1}")).()
  end

  defp verify_user_session(token, conn) when is_binary(token) do
    token
    |> Accounts.get_user_session()
    |> maybe_refresh_session(conn)
  end

  defp verify_user_session(nil, conn) do
    unauthorized_response(conn)
  end

  defp maybe_refresh_session(nil, conn) do
    unauthorized_response(conn)
  end

  defp maybe_refresh_session(%UserSession{user_id: user_id}, conn) do
    conn
    |> Authentication.set_auth_header(user_id)
  end

  defp unauthorized_response(conn) do
    conn
    |> Plug.Conn.put_status(:unauthorized)
    |> Phoenix.Controller.json(%{})
    |> Plug.Conn.halt()
  end

  defp user_id_matches_session?(conn, user_id) do
    user_id == get_session(conn, :user_id)
  end
end
