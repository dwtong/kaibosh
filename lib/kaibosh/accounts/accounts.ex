defmodule Kaibosh.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.Accounts.UserSession
  alias Kaibosh.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def sign_in(email, pass) do
    with %User{} = user <- Repo.get_by(User, email: email),
         {:ok, %User{id: id}} <- User.check_password(user, pass) do
      %UserSession{}
      |> UserSession.changeset(%{user_id: id})
      |> Repo.insert()
    else
      nil -> {:error, :invalid_user}
    end
  end

  def sign_out(token) do
    UserSession
    |> where(token: ^token)
    |> Repo.delete_all()
  end

  def get_user_session(session_token) do
    UserSession
    |> where(token: ^session_token)
    |> Repo.one()
  end
end
