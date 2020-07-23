defmodule Kaibosh.Plans.Session do
  alias Kaibosh.Date

  def put_date(%{session: %{time: time, day: day}} = session, week_starts_at) do
    session_date =
      week_starts_at
      |> Date.utc_datetime_from_local_date_and_time(time)
      |> Date.date_for_day_of_week(day)

    put_in(session, [:session, :date], session_date)
  end

end
