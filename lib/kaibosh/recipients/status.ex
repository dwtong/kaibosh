defmodule Kaibosh.Recipients.Status do
  @moduledoc """
  Generates a status for a recipient.

  The recipient status is based on both the recipient
  schema and on any associated sessions and holds.
  """
  alias Kaibosh.Recipients.Recipient
  import Kaibosh.Date

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

  defp starts_in_future?(%Recipient{started_at: started_at}), do: future_date?(started_at)

  defp all_sessions_on_hold?(%Recipient{session_count: sessions, hold_count: holds}) do
    holds && holds > 0 && holds == sessions
  end
end
