defmodule Kaibosh.Date do
  @moduledoc """
  Various helper functions for handling dates.
  """
  @one_day 60 * 60 * 24

  def now, do: DateTime.utc_now()
  def yesterday, do: sub_days(1)
  def tomorrow, do: add_days(1)

  def sub_days(days), do: add_days(days * -1)
  def add_days(days), do: DateTime.add(now(), days * @one_day, :second)

  def future_date?(date), do: DateTime.compare(date, now()) == :gt
  def past_date?(date), do: !future_date?(date)
  def today?(datetime), do: DateTime.to_date(datetime) == DateTime.to_date(now())
end
