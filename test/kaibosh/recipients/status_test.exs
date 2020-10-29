defmodule Kaibosh.Recipients.StatusTest do
  use Kaibosh.DataCase
  import Kaibosh.Recipients.Query
  alias Kaibosh.Recipients.Status

  describe "status for recipient with no sessions" do
    test "is pending if start date is in future" do
      %{id: recipient_id} = insert(:recipient, started_at: tomorrow())
      assert fetch_status(recipient_id) == :pending
    end

    test "is pending if start date is in the past and no recipient session is set" do
      %{id: recipient_id} = insert(:recipient, started_at: yesterday())
      assert fetch_status(recipient_id) == :pending
    end

    test "is pending if they have not completed onboarding checklist items" do
      %{id: recipient_id} = insert(:recipient, met_kaibosh_at: nil, signed_terms_at: nil)
      assert fetch_status(recipient_id) == :pending
    end

    test "is active when they have completed onboarding checklist items" do
      recipient =
        insert(:recipient,
          signed_terms_at: ~U[2020-01-01T00:00:00Z],
          met_kaibosh_at: ~U[2020-01-01T00:00:00Z]
        )

      insert(:recipient_session, recipient: recipient)

      assert fetch_status(recipient.id) == :active
    end

    test "is pending if start date is not set" do
      %{id: recipient_id} = insert(:recipient, started_at: nil)
      assert fetch_status(recipient_id) == :pending
    end

    test "is archived if archived at date is set" do
      %{id: recipient_id} = insert(:recipient, archived_at: ~U[2020-01-01T00:00:00Z])
      assert fetch_status(recipient_id) == :archived
    end
  end

  describe "status for recipient with sessions" do
    test "is active if they have started and have active sessions" do
      %{recipient_id: recipient_id} = insert(:recipient_session)
      assert fetch_status(recipient_id) == :active
    end

    test "is active if session hold starts in future" do
      %{recipient_session: %{recipient_id: recipient_id}} =
        insert(:hold, %{starts_at: tomorrow(), ends_at: nil})

      assert fetch_status(recipient_id) == :active
    end

    test "is on hold if session hold is current with end date" do
      %{recipient_session: %{recipient_id: recipient_id}} =
        insert(:hold, %{starts_at: yesterday(), ends_at: tomorrow()})

      assert fetch_status(recipient_id) == :on_hold
    end

    test "is on hold if session hold is current without end date" do
      %{recipient_session: %{recipient_id: recipient_id}} =
        insert(:hold, %{starts_at: yesterday(), ends_at: nil})

      assert fetch_status(recipient_id) == :on_hold
    end

    test "is on hold if session has multiple holds" do
      %{recipient_session: %{recipient_id: recipient_id} = recipient_session} =
        insert(:hold, %{starts_at: yesterday(), ends_at: nil})

      insert(:hold, %{
        starts_at: yesterday(),
        ends_at: tomorrow(),
        recipient_session: recipient_session
      })

      assert fetch_status(recipient_id) == :on_hold
    end

    test "is active if session has multiple holds and active session exists" do
      %{recipient_session: %{recipient_id: recipient_id} = recipient_session} =
        insert(:hold, %{starts_at: yesterday(), ends_at: nil})

      insert(:hold, %{
        starts_at: yesterday(),
        ends_at: tomorrow(),
        recipient_session: recipient_session
      })

      insert(:recipient_session, recipient_id: recipient_id, recipient: nil)

      assert fetch_status(recipient_id) == :active
    end

    test "is active if session hold has finished" do
      %{recipient_session: %{recipient_id: recipient_id}} =
        insert(:hold, %{starts_at: sub_days(7), ends_at: sub_days(1)})

      assert fetch_status(recipient_id) == :active
    end

    test "is active if they have one session on hold and another that is active" do
      %{recipient_session: %{recipient_id: recipient_id}} =
        insert(:hold, %{starts_at: yesterday()})

      insert(:recipient_session, recipient: nil, recipient_id: recipient_id)

      assert fetch_status(recipient_id) == :active
    end
  end

  defp fetch_status(recipient_id) do
    recipient_id
    |> get_recipient_by_id()
    |> Repo.one!()
    |> Status.get()
  end
end
