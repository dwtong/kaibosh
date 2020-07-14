defmodule Kaibosh.DateHelper do
  @moduledoc """
  Assorted date helpers to use in unit tests.
  """

  @one_day 60 * 60 * 24
  @now DateTime.utc_now()

  def today?(datetime), do: DateTime.to_date(datetime) == DateTime.to_date(@now)
  def tomorrow, do: add_days(1)
  def yesterday, do: sub_days(1)
  def sub_days(days), do: add_days(days * -1)
  def add_days(days), do: DateTime.add(@now, days * @one_day, :second)
end
