defmodule Kaibosh.Recipients.Status do
  alias Kaibosh.Recipients.Recipient
  import Ecto.Query

  def put({:ok, recipient}), do: {:ok, put(recipient)}
  def put(%Recipient{} = recipient), do: %{recipient | status: status(recipient)}
  def put(error), do: error

  def get(%Recipient{} = recipient), do: status(recipient)

  defp status(%Recipient{archived_at: archived_at}) when not is_nil(archived_at), do: :archived
  defp status(%Recipient{started_at: nil}), do: :pending
  defp status(%Recipient{signed_terms_at: nil}), do: :pending
  defp status(%Recipient{met_kaibosh_at: nil}), do: :pending
  defp status(%Recipient{session_count: nil}), do: :pending

  defp status(%Recipient{} = recipient) do
    cond do
      starts_in_future?(recipient) -> :pending
      all_sessions_on_hold?(recipient) -> :on_hold
      true -> :active
    end
  end

  defp starts_in_future?(%Recipient{started_at: started_at}) do
    DateTime.compare(started_at, DateTime.utc_now()) == :gt
  end

  defp all_sessions_on_hold?(%Recipient{session_count: sessions, hold_count: holds}) do
    holds && holds > 0 && holds == sessions
  end

  def recipient_with_status_query do
    Recipient
    |> join(:left, [r], s in subquery(sessions_query()), on: r.id == s.recipient_id)
    |> join(:left, [r, s], h in subquery(holds_query()), on: r.id == h.recipient_id)
    |> select_merge([r, s, h], %{r | session_count: s.count, hold_count: h.count})
  end

  defp sessions_query do
    "recipient_sessions"
    |> group_by([s], s.recipient_id)
    |> select([s], %{count: count(s.id), recipient_id: s.recipient_id})
  end

  defp holds_query do
    "holds"
    |> join(:inner, [h], s in "recipient_sessions", on: s.id == h.recipient_session_id)
    |> where([h], h.starts_at < ^DateTime.utc_now())
    |> where([h], is_nil(h.ends_at) or h.ends_at > ^DateTime.utc_now())
    |> group_by([h, s], s.recipient_id)
    |> select([h, s], %{count: count(h.id), recipient_id: s.recipient_id})
  end
end
