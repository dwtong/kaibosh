defmodule KaiboshWeb.UserController do
  use KaiboshWeb, :controller

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User
  alias KaiboshWeb.Password
  alias KaiboshWeb.Email

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    user_params = %{email: email, password: :crypto.strong_rand_bytes(16)}

    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
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
end
