defmodule Kaibosh.Date do
  @moduledoc """
  Various helper functions for handling dates.
  """

  def now, do: DateTime.utc_now()
  def yesterday, do: sub_days(1)
  def tomorrow, do: add_days(1)

  def sub_days(days), do: add_days(days * -1)
  def add_days(days), do: Timex.shift(now(), days: days)

  def future_date?(date), do: after?(date, now())
  def past_date?(date), do: !future_date?(date)
  def today?(datetime), do: DateTime.to_date(datetime) == DateTime.to_date(now())
  def after?(date, start_at), do: Timex.after?(date, start_at)
  def between?(date, start_at, end_at), do: Timex.between?(date, start_at, end_at)

  def weekday_offset(day) do
    day = String.capitalize(day)
    day_num = Enum.find(1..7, &(Elixir.Timex.day_name(&1) == day))
    day_num - 1
  end

  def utc_datetime_from_local_date_and_time(
        %Date{year: y, month: mo, day: d},
        %Time{hour: h, minute: mi, second: s},
        timezone \\ "Pacific/Auckland"
      ) do
    Timex.to_datetime({{y, mo, d}, {h, mi, s}}, timezone)
  end

  def date_for_day_of_week(datetime, day) do
    offset = weekday_offset(day)
    Timex.shift(datetime, days: offset)
  end
end
