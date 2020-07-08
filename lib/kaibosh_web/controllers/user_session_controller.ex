defmodule KaiboshWeb.UserSessionController do
  use KaiboshWeb, :controller

  alias Kaibosh.Accounts
  alias KaiboshWeb.Authentication

  action_fallback KaiboshWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.sign_in(email, password) do
      {:ok, %{id: id, token: token}} ->
        conn
        |> Authentication.set_session_cookie(token)
        |> Authentication.set_auth_header(id)
        |> put_status(:created)
        |> render("created.json")

      _ ->
        conn
        |> put_status(:not_found)
        |> render("not_found.json")
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.destroy_session()
    |> send_resp(:no_content, "")
  end
end
