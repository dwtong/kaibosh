defmodule Kaibosh.Accounts.Query do
  @moduledoc """
  Queries used by Accounts context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query
  alias Kaibosh.Accounts.UserSession

  def get_session_by_token(token) do
    UserSession
    |> where(token: ^token)
  end

  def get_notification_by_user_base_ids(user_id, base_id) do
    "user_base_notifications"
    |> where(user_id: ^user_id, base_id: ^base_id)
  end

  def base_notifications_for_user(user_id) do
    "user_base_notifications"
    |> where(user_id: ^user_id)
    |> select([ubn], ubn.base_id)
  end
end
