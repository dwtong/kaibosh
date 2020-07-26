defmodule Kaibosh.RecipientSessions.StatusTest do
  use Kaibosh.DataCase
  alias Kaibosh.RecipientSessions.Status

  test "is active if no hold dates are set" do
    %{status: status} = insert(:recipient_session, holds: []) |> Status.put()
    assert status == :active
  end

  test "is active if start date is in future" do
    hold = %{starts_at: tomorrow()}
    %{status: status} = insert(:recipient_session, holds: [hold]) |> Status.put()

    assert status == :active
  end

  test "is active if end date is in past" do
    hold = %{starts_at: sub_days(2), ends_at: sub_days(1)}
    %{status: status} = insert(:recipient_session, holds: [hold]) |> Status.put()
    assert status == :active
  end

  test "is on hold if start date is in the past and no end date is set" do
    hold = %{starts_at: yesterday(), ends_at: nil}
    %{status: status} = insert(:recipient_session, holds: [hold]) |> Status.put()
    assert status == :on_hold
  end

  test "is on hold if start date is in the past and end date is in the future" do
    hold = %{starts_at: yesterday(), ends_at: tomorrow()}
    %{status: status} = insert(:recipient_session, holds: [hold]) |> Status.put()
    assert status == :on_hold
  end

  test "is on hold if there is an active hold and other inactive holds" do
    hold_1 = %{starts_at: tomorrow()}
    hold_2 = %{starts_at: yesterday()}
    %{status: status} = insert(:recipient_session, holds: [hold_1, hold_2]) |> Status.put()
    assert status == :on_hold
  end
end
