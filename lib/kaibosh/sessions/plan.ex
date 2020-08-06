defmodule Kaibosh.Sessions.Plan do
  defstruct [:session, :recipients, :allocations]

  alias Kaibosh.Date
  alias Kaibosh.Sessions.Plan
  alias Kaibosh.RecipientSessions.RecipientSession
  alias Kaibosh.RecipientSessions.Status

  def new(session) do
    %Plan{
      session: %{date: session.date, id: session.id, day: session.day, time: session.time, base_id: session.base_id},
      recipients: build_recipients(session)
    }
  end

  defp build_recipients(%{recipient_sessions: []}), do: []

  defp build_recipients(%{recipient_sessions: recipient_sessions, date: session_date}) do
    recipient_sessions
    |> Enum.reject(&inactive_recipient?(&1.recipient, session_date))
    |> Enum.map(&recipient_with_status/1)
  end

  defp recipient_with_status(%RecipientSession{recipient: %{id: id, name: name, description: description}} = session) do
    %{status: Status.get(session), name: name, id: id, description: description}
  end

  defp inactive_recipient?(%{archived_at: archived_at}, _date) when not is_nil(archived_at) do
    true
  end

  defp inactive_recipient?(%{signed_terms_at: nil}, _date), do: true
  defp inactive_recipient?(%{met_kaibosh_at: nil}, _date), do: true
  defp inactive_recipient?(%{started_at: nil}, _date), do: true

  defp inactive_recipient?(%{started_at: started_at}, date) do
    Date.after?(started_at, date)
  end
end
