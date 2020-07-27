defmodule KaiboshWeb.UserController do
  use KaiboshWeb, :controller

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User

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

  def update(conn, %{"id" => _user_id, "user" => user_params}) do
    # Currently only allow user to update themselves
    user_id = conn |> fetch_session() |> get_session(:user_id)

    with %User{} = user <- Accounts.get_user!(user_id),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    else
      _err -> {:error, :not_found}
    end
  end
end
