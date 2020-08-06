defmodule Kaibosh.Sessions.Query do
  @moduledoc """
  Queries used by Sessions context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query
  alias Kaibosh.Sessions.Session

  def get_sessions_by_base_id(base_id) do
    Session
    |> where(base_id: ^base_id)
  end

  def get_sessions_with_recipients(base_id) do
    Session
    |> where([s], s.base_id == ^base_id)
    |> preload(recipient_sessions: [:recipient, :holds])
  end
end
