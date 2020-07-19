defmodule Kaibosh.Recipients.Query do
  @moduledoc """
  Queries used by Recipients context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query
  alias Kaibosh.Recipients.Recipient

  def get_recipient_by_id(id) do
    get_recipients()
    |> where(id: ^id)
    |> join(:left, [r], c in assoc(r, :contact))
    |> preload(:contact)
  end

  def get_recipients do
    Recipient
    |> join(:left, [r], s in subquery(active_sessions()), on: r.id == s.recipient_id)
    |> join(:left, [r, s], h in subquery(active_holds()), on: r.id == h.recipient_id)
    |> select_merge([r, s, h], %{r | session_count: s.count, hold_count: h.count})
  end

  defp active_sessions do
    "recipient_sessions"
    |> group_by([s], s.recipient_id)
    |> select([s], %{count: count(s.id), recipient_id: s.recipient_id})
  end

  defp active_holds do
    "holds"
    |> join(:inner, [h], s in "recipient_sessions", on: s.id == h.recipient_session_id)
    |> where([h], h.starts_at < ^DateTime.utc_now())
    |> where([h], is_nil(h.ends_at) or h.ends_at > ^DateTime.utc_now())
    |> group_by([h, s], s.recipient_id)
    |> select([h, s], %{count: count(h.id), recipient_id: s.recipient_id})
  end
end
