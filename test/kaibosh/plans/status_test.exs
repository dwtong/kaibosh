defmodule Kaibosh.Plans.StatusTest do
  use Kaibosh.DataCase
  alias Kaibosh.Plans.Status

  test "status is active when sessions on hold in future" do
    holds = [%{hold: %{starts_at: tomorrow(), ends_at: nil}}]
    date = now()
    assert %{status: :active} = Status.put(%{}, holds, date)
  end

  test "status is active when sessions were on hold in past" do
    holds = [%{hold: %{starts_at: sub_days(14), ends_at: sub_days(7)}}]
    date = now()
    assert %{status: :active} = Status.put(%{}, holds, date)
  end

  test "status is on hold when sessions are on hold with end date" do
    holds = [%{hold: %{starts_at: yesterday(), ends_at: tomorrow()}}]
    date = now()
    assert %{status: :on_hold} = Status.put(%{}, holds, date)
  end

  test "status is on hold when sessions are on hold indefinitely" do
    holds = [%{hold: %{starts_at: yesterday(), ends_at: nil}}]
    date = now()
    assert %{status: :on_hold} = Status.put(%{}, holds, date)
  end
end
