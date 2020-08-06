defmodule Kaibosh.RecipientSessions.Status do
  @moduledoc """
  Generates a status for a recipient session.
  """
  alias Kaibosh.Date
  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession

  def put({:ok, recipient_session}), do: {:ok, put(recipient_session)}
  def put(%RecipientSession{} = session), do: %{session | status: status(session)}
  def put(error), do: error

  def get(%RecipientSession{} = session), do: status(session)

  defp status(recipient_session, date \\ Date.now())

  defp status(%RecipientSession{holds: %Ecto.Association.NotLoaded{}}, _date) do
    raise("RecipientSession holds not loaded")
  end

  defp status(%RecipientSession{holds: holds}, date) when is_list(holds) do
    case on_hold?(holds, date) do
      true -> :on_hold
      false -> :active
    end
  end

  defp on_hold?(holds, session_date) when is_list(holds) do
    Enum.any?(holds, fn
      %{starts_at: nil, ends_at: nil} ->
        false

      %{starts_at: hold_starts_at, ends_at: nil} ->
        Date.after?(session_date, hold_starts_at)

      %{starts_at: hold_starts_at, ends_at: hold_ends_at} ->
        Date.between?(session_date, hold_starts_at, hold_ends_at)
    end)
  end

  defp on_hold?(_holds, _session_date), do: false
end
