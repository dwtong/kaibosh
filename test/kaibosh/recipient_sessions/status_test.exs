defmodule Kaibosh.RecipientSessions.StatusTest do
  use Kaibosh.DataCase
  alias Kaibosh.RecipientSessions.Status

  describe "status for current date" do
    test "is active if no hold dates are set" do
      assert %{status: :active} = insert(:recipient_session, holds: []) |> Status.put()
    end

    test "is active if start date is in future" do
      hold = %{starts_at: tomorrow()}
      assert %{status: :active} = insert(:recipient_session, holds: [hold]) |> Status.put()
    end

    test "is active if end date is in past" do
      hold = %{starts_at: sub_days(2), ends_at: sub_days(1)}
      assert %{status: :active} = insert(:recipient_session, holds: [hold]) |> Status.put()
    end

    test "is on hold if start date is in the past and no end date is set" do
      hold = %{starts_at: yesterday(), ends_at: nil}
      assert %{status: :on_hold} = insert(:recipient_session, holds: [hold]) |> Status.put()
    end

    test "is on hold if start date is in the past and end date is in the future" do
      hold = %{starts_at: yesterday(), ends_at: tomorrow()}
      assert %{status: :on_hold} = insert(:recipient_session, holds: [hold]) |> Status.put()
    end

    test "is on hold if there is an active hold and other inactive holds" do
      hold_1 = %{starts_at: tomorrow()}
      hold_2 = %{starts_at: yesterday()}

      assert %{status: :on_hold} =
               insert(:recipient_session, holds: [hold_1, hold_2]) |> Status.put()
    end
  end

  describe "status for defined dates" do
    test "is active with no holds" do
      date = ~D[2020-01-01]
      session = insert(:recipient_session, holds: [])

      assert Status.get_for_date(session, date) == :active
    end

    test "is active when sessions on hold in future" do
      hold = %{starts_at: ~U[2020-02-28 00:00:00Z], ends_at: nil}
      date = ~D[2020-01-01]
      session = insert(:recipient_session, holds: [hold])

      assert Status.get_for_date(session, date) == :active
    end

    test "is active when sessions were on hold in past" do
      hold = %{starts_at: ~U[2019-02-28 00:00:00Z], ends_at: ~U[2019-03-28 00:00:00Z]}
      date = ~D[2020-01-01]
      session = insert(:recipient_session, holds: [hold])

      assert Status.get_for_date(session, date) == :active
    end

    test "is on hold when sessions are on hold with end date" do
      hold = %{starts_at: ~U[2020-02-28 00:00:00Z], ends_at: ~U[2021-02-28 00:00:00Z]}
      date = ~D[2020-03-01]
      session = insert(:recipient_session, holds: [hold])

      assert Status.get_for_date(session, date) == :on_hold
    end

    test "is on hold when sessions are on hold indefinitely" do
      hold = %{starts_at: ~U[2020-02-28 00:00:00Z], ends_at: nil}
      date = ~D[2020-03-01]
      session = insert(:recipient_session, holds: [hold])

      assert Status.get_for_date(session, date) == :on_hold
    end
  end
end
