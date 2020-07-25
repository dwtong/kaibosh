defmodule Kaibosh.Plans.Session do
  alias Kaibosh.Date
  alias Kaibosh.Plans.Status

  def build_sessions(sessions, week_starts_at) when is_list(sessions) do
    sessions
    |> Enum.map(&put_date(&1, week_starts_at))
    |> Enum.group_by(& &1.session)
    |> Enum.map(&build_session(&1))
  end

  def build_session({session, recipients}) do
    %{
      session: session,
      recipients: merge_session_recipients(session, recipients)
    }
  end

  def put_date(%{session: %{time: time, day: day}} = session, week_starts_at) do
    session_date =
      week_starts_at
      |> Date.utc_datetime_from_local_date_and_time(time)
      |> Date.date_for_day_of_week(day)

    put_in(session, [:session, :date], session_date)
  end

  def merge_session_recipients(session, recipients) do
    recipients
    |> Enum.group_by(& &1.recipient)
    |> Enum.map(&build_recipient(&1, session.date))
  end

  def build_recipient({recipient, holds}, session_date) do
    recipient
    |> Map.delete(:session)
    |> Status.put(holds, session_date)
  end
end
