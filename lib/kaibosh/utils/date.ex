defmodule Kaibosh.Utils.Date do
  @moduledoc """
  Various helper functions for handling dates.
  """
  def future_date?(date) do
    DateTime.compare(date, DateTime.utc_now()) == :gt
  end

  def past_date?(date), do: !future_date?(date)
end
