defmodule Kaibosh.RecipientSessions.Status do
  @moduledoc """
  Generates a status for a recipient session.
  """
  import Kaibosh.Date
  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession

  def put({:ok, recipient_session}), do: {:ok, put(recipient_session)}
  def put(%RecipientSession{} = session), do: %{session | status: status(session)}
  def put(error), do: error

  def get(%RecipientSession{} = session), do: status(session)

  defp status(%RecipientSession{holds: %Ecto.Association.NotLoaded{}}) do
    raise("RecipientSession holds not loaded")
  end

  defp status(%RecipientSession{holds: holds}) when is_list(holds) do
    case Enum.any?(holds, &active_hold?/1) do
      true -> :on_hold
      false -> :active
    end
  end

  defp active_hold?(%Hold{starts_at: starts_at, ends_at: nil}) do
    past_date?(starts_at)
  end

  defp active_hold?(%Hold{starts_at: starts_at, ends_at: ends_at}) do
    past_date?(starts_at) && future_date?(ends_at)
  end
end
