defmodule Kaibosh.Plans.Status do
  @moduledoc """
  Gets the status for a recipient for the session on a specific date.

  Different than Kaibosh.Recipient.Status module because it also accounts
  for past and future dates.
  """

  alias Kaibosh.Date

  def put(recipient, holds, session_date) do
    Map.put(recipient, :status, status(holds, session_date))
  end

  defp status(holds, session_date) do
    case on_hold?(holds, session_date) do
      true -> :on_hold
      false -> :active
    end
  end

  defp on_hold?(holds, session_date) when is_list(holds) do
    Enum.any?(holds, fn
      %{hold: %{starts_at: nil, ends_at: nil}} ->
        false

      %{hold: %{starts_at: hold_starts_at, ends_at: nil}} ->
        Date.after?(session_date, hold_starts_at)

      %{hold: %{starts_at: hold_starts_at, ends_at: hold_ends_at}} ->
        Date.between?(session_date, hold_starts_at, hold_ends_at)
    end)
  end

  defp on_hold?(_holds, _session_date), do: false
end
