defmodule Kaibosh.RecipientSessions.Query do
  @moduledoc """
  Queries used by RecipientSessions context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query
  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession

  def get_sessions_for_recipient(recipient_id) do
    RecipientSession
    |> where(recipient_id: ^recipient_id)
    |> preload([:allocations, :holds, :session])
  end

  def get_session_by_id(id) do
    RecipientSession
    |> where(id: ^id)
    |> preload([:allocations, :holds, :session])
  end

  def get_hold_by_id_and_recipient_id(hold_id, recipient_id) do
    Hold
    |> join(:inner, [h], rs in assoc(h, :recipient_session))
    |> where([h, rs], rs.recipient_id == ^recipient_id and h.id == ^hold_id)
  end
end
