defmodule Kaibosh.Plans.Query do
  @moduledoc """
  Queries used by Plans context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query

  def get_recipients_and_sessions_by_base(base_id, starts_at) do
    {:ok, base_id} = Ecto.Type.cast(:integer, base_id)

    "sessions"
    |> join(:inner, [s], rs in "recipient_sessions", on: s.id == rs.session_id)
    |> join(:inner, [s, rs], r in subquery(active_recipients(base_id, starts_at)),
      on: r.id == rs.recipient_id
    )
    |> join(:left, [s, rs], h in "holds", on: rs.id == h.recipient_session_id)
    |> where([s], s.base_id == ^base_id)
    |> group_by([s, rs, r, h], [
      s.id,
      s.day,
      s.time,
      r.name,
      r.id,
      r.description,
      h.starts_at,
      h.ends_at
    ])
    |> select([s, rs, r, h], %{
      session: %{id: s.id, day: s.day, time: s.time, base_id: s.base_id},
      recipient: %{name: r.name, id: r.id, description: r.description},
      hold: %{starts_at: h.starts_at, ends_at: h.ends_at}
    })
  end

  def get_recipients_for_session(base_id, session_id, session_date) do
    {:ok, session_id} = Ecto.Type.cast(:integer, session_id)

    base_id
    |> get_recipients_and_sessions_by_base(session_date)
    |> where([s], s.id == ^session_id)
  end

  def get_allocations_for_session(session_id) do
    {:ok, session_id} = Ecto.Type.cast(:integer, session_id)

    "recipient_sessions"
    |> join(:inner, [rs], a in "allocations", on: a.recipient_session_id == rs.id)
    |> where([rs], rs.session_id == ^session_id)
    |> select([rs, a], %{
      recipient_id: rs.recipient_id,
      category_id: a.category_id,
      quantity: a.quantity
    })
  end

  defp active_recipients(base_id, starts_on) do
    starts_at = Timex.to_datetime(starts_on)

    "recipients"
    |> where([r], r.base_id == ^base_id)
    |> where([r], is_nil(r.archived_at))
    |> where([r], r.started_at <= ^starts_at)
    |> where([r], not is_nil(r.signed_terms_at))
    |> where([r], not is_nil(r.met_kaibosh_at))
    |> select([r], %{id: r.id, name: r.name, description: r.description})
  end
end
