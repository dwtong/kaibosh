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

  def get_recipients_with_params(params) do
    Recipient
    |> join(:left, [r], s in subquery(active_sessions()), on: r.id == s.recipient_id)
    |> join(:left, [r, s], h in subquery(active_holds()), on: r.id == h.recipient_id)
    |> where(^filter_where(params))
    |> select_merge([r, s, h], %{r | session_count: s.count, hold_count: h.count})
  end

  defp filter_where(params) do
    Enum.reduce(params, dynamic(true), fn
      {"name", name_string}, dynamic ->
        dynamic([r], ^dynamic and ilike(r.name, ^"%#{name_string}%"))

      {"base", base_id}, dynamic when base_id > 0 ->
        dynamic([r], ^dynamic and r.base_id == ^base_id)

      {_, _}, dynamic ->
        dynamic
    end)
  end

  defp active_sessions do
    "recipient_sessions"
    |> join(:left, [rs], h in "holds", on: rs.id == h.recipient_session_id)
    |> group_by([rs], rs.recipient_id)
    |> select([rs], %{count: count(), recipient_id: rs.recipient_id})
  end

  defp active_holds do
    "holds"
    |> join(:inner, [h], rs in "recipient_sessions", on: rs.id == h.recipient_session_id)
    |> where([h], h.starts_at < ^DateTime.utc_now())
    |> where([h], is_nil(h.ends_at) or h.ends_at > ^DateTime.utc_now())
    |> group_by([h, rs], rs.recipient_id)
    |> select([h, rs], %{count: count(h.id), recipient_id: rs.recipient_id})
  end
end
