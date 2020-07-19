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
end
