defmodule Kaibosh.DateHelper do
  def today?(datetime) do
    DateTime.to_date(datetime) == DateTime.to_date(DateTime.utc_now())
  end
end
