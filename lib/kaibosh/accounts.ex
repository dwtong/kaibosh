defmodule Kaibosh.Accounts do
  @moduledoc """
  The Accounts context.
  """
    import Kaibosh.Accounts.Query

  alias Kaibosh.Accounts.User
  alias Kaibosh.Accounts.UserSession
  alias Kaibosh.Repo

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

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

  def subscribe_user_to_base_notifications(%User{id: user_id}, base_id) do
    "user_base_notifications"
    |> Repo.insert_all([%{user_id: user_id, base_id: base_id}])
    |> case do
      {1, nil} -> :ok
      _ -> :error
    end
  end

  def unsubscribe_user_from_base_notifications(%User{id: user_id}, base_id) do
    get_notification_by_user_base_ids(user_id, base_id)
    |> Repo.delete_all()
    |> case do
      {1, nil} -> :ok
      _ -> :error
    end
  end

  def get_base_notifications_for_user(%User{id: user_id}) do
    user_id
    |> base_notifications_for_user()
    |> Repo.all()
  end

  def sign_in(email, pass) do
    with %User{} = user <- Repo.get_by(User, email: email),
         {:ok, %User{id: id}} <- User.check_password(user, pass) do
      %UserSession{}
      |> UserSession.changeset(%{user_id: id})
      |> Repo.insert()
    else
      _error -> {:error, :invalid_user}
    end
  end

  def sign_out(session_token) do
    session_token
    |> get_session_by_token()
    |> Repo.delete_all()
  end

  def get_user_session(session_token) do
    session_token
    |> get_session_by_token()
    |> Repo.one()
  end
end
