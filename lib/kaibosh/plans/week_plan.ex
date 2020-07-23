defmodule Kaibosh.Plans.WeekPlan do
  @moduledoc """
  Session plan that only lists recipients.
  Categories and allocations are ignored.
  """
  defstruct [:session, :recipients]

  alias Kaibosh.Plans.Session
  alias Kaibosh.Plans.Status
  alias Kaibosh.Plans.WeekPlan

  def build(sessions, week_starts_at) do
    sessions
    |> Enum.map(&Session.put_date(&1, week_starts_at))
    |> Enum.group_by(& &1.session)
    |> Enum.map(&merge_recipients(&1))
  end

  defp merge_recipients({session, recipients}) do
    recipients =
      recipients
      |> Enum.group_by(& &1.recipient)
      |> Enum.map(&build_recipient(&1, session.date))

    %WeekPlan{session: session, recipients: recipients}
  end

  defp build_recipient({recipient, holds}, session_date) do
    recipient
    |> Map.delete(:session)
    |> Status.put(holds, session_date)
  end
end
