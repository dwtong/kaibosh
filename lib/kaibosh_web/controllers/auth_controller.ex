defmodule KaiboshWeb.AuthController do
  use KaiboshWeb, :controller

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User

  alias KaiboshWeb.Authentication
  alias KaiboshWeb.Email
  alias KaiboshWeb.Password

  action_fallback KaiboshWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.sign_in(email, password) do
      {:ok, token} ->
        conn
        |> Authentication.create_session(token)
        |> put_status(:created)
        |> render("created.json")

      _ ->
        conn
        |> put_status(:not_found)
        |> render("not_found.json")
    end
  end

  def password_reset(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- Password.generate_token(email) do
      Email.reset_password_email(user)

      conn
      |> put_status(:created)
      |> render("password_sent.json")
    else
      _err ->
        conn
        |> put_status(:not_found)
        |> render("not_found.json")
    end
  end

  def update_password(conn, %{
        "password" => password,
        "password_confirmation" => confirmation,
        "token" => token
      }) do
    with {:ok, user} <- Password.validate_token(token),
         true <- Password.check_match(password, confirmation),
         {:ok, %User{}} <- Accounts.update_user(user, %{password: password}) do
      conn
      |> put_status(:ok)
      |> render("password_updated.json")
    else
      _err -> send_resp(conn, :unprocessable_entity, "")
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.destroy_session()
    |> send_resp(:no_content, "")
  end
end
