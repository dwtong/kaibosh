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

  def get_allocations_for_session(session_id, recipient_ids) do
    {:ok, session_id} = Ecto.Type.cast(:integer, session_id)

    "recipient_sessions"
    |> join(:inner, [rs], a in "allocations", on: a.recipient_session_id == rs.id)
    |> where([rs], rs.session_id == ^session_id)
    |> where([rs], rs.recipient_id in ^recipient_ids)
    |> select([rs, a], %{
      recipient_id: rs.recipient_id,
      category_id: a.category_id,
      quantity: a.quantity
    })
  end

  def list_sessions_with_recipients(base_id) do
    Session
    |> where([s], s.base_id == ^base_id)
    |> preload(recipient_sessions: [:recipient, :holds])
  end

  def get_session_with_recipients(session_id) do
    Session
    |> where([s], s.id == ^session_id)
    |> preload(recipient_sessions: [:recipient, :holds])
  end
end
