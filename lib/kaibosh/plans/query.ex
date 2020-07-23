defmodule Kaibosh.Plans.Query do
  @moduledoc """
  Queries used by Plans context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query

  # (base_id, week_of_date) do
  def get_plans_by_base(base_id, starts_at) do
    {:ok, base_id} = Ecto.Type.cast(:integer, base_id)

    "sessions"
    |> join(:inner, [s], rs in "recipient_sessions", on: s.id == rs.session_id)
    |> join(:inner, [s, rs], r in subquery(active_recipients(base_id, starts_at)),
      on: r.id == rs.recipient_id
    )
    |> join(:left, [s, rs], h in "holds", on: rs.id == h.recipient_session_id)
    |> where([s], s.base_id == ^base_id)
    |> group_by([s, rs, r, h], [s.id, s.day, s.time, r.name, r.id, h.starts_at, h.ends_at])
    |> select([s, rs, r, h], %{
      session: %{id: s.id, day: s.day, time: s.time},
      recipient: %{name: r.name, id: r.id},
      hold: %{starts_at: h.starts_at, ends_at: h.ends_at}
    })
  end

  # def get_plans_by_base(base_id, _starts_at) do
  #   "sessions"
  #   |> join(:inner, [s], rs in "recipient_sessions", on: s.id == rs.session_id)
  #   |> join(:inner, [s, rs], r in "recipients", on: r.id == rs.recipient_id)
  #   # |> join(:inner, [s, rs], r in subquery(active_recipients(base_id, starts_at)),
  #   #   on: r.id == rs.recipient_id
  #   # )
  #   |> join(:inner, [s, rs], h in "holds", on: rs.id == h.recipient_session_id)
  #   |> where([s], s.base_id == ^base_id)
  #   |> select([s, rs, r], %{session_id: s.id, recipient: %{name: r.name, id: r.id}})
  # end

  # def get_plans_by_base_and_week_date(base_id, _week_of_date) do
  #   |> group_by([s, rs, r], [s.id, s.day, s.time, r.name, r.id])
  #   |> select([s, rs, r], %{s.id, s.day, s.time, recipient: %{name: r.name, id: r.id}})
  # end

  # def get_plan_for_session_by_date(session_id, date) do
  #   date
  #   |> sessions_with_recipients()
  #   |> where(id: ^session_id)
  # end

  # defp sessions_with_recipients(date) do
  #   "sessions"
  #   |> join(:inner, [s], rs in "recipient_sessions", as: :rs, on: rs.session_id == s.id)
  #   |> join(:inner, [rs: rs], r in active_recipients(date), as: :r, on: r.id == rs.recipient_id)
  # end

  defp active_recipients(base_id, starts_on) do
    starts_at = Timex.to_datetime(starts_on)

    "recipients"
    |> where([r], r.base_id == ^base_id)
    |> where([r], is_nil(r.archived_at))
    |> where([r], r.started_at <= ^starts_at)
    |> where([r], not is_nil(r.signed_terms_at))
    |> where([r], not is_nil(r.met_kaibosh_at))
    |> select([r], %{id: r.id, name: r.name})
  end

  # defp with_details(recipient_session_id) do
  #   "allocations"
  #   |> where([a], a.recipient_session_id == ^recipient_session_id)
  #   |> join(:inner, [a], c in "categories", on: a.category_id == c.id)
  #   |> select([a, c], %{category: c, quantity: a.quantity})
  # end

  # defp d do
  #   "recipient_sessions"
  #   |> join(:inner, [rs], "recipients")
  #   |> select([])
  # end
end
