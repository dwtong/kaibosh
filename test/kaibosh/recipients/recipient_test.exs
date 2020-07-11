defmodule Kaibosh.Recipients.RecipientTest do
  use Kaibosh.DataCase

  alias Kaibosh.Recipients.Recipient

  describe "recipient status" do
      test "is pending if start date is in future" do
        recipient = build(:recipient, started_at: tomorrow())
        assert Recipient.status(recipient) == :pending
      end

      test "is active if start date is in past" do
        recipient = build(:recipient, started_at: yesterday())
        assert Recipient.status(recipient) == :active
      end

      test "is pending if they have not completed onboarding checklist items" do
        recipient = build(:recipient, met_kaibosh_at: nil, signed_terms_at: nil)
        assert Recipient.status(recipient) == :pending
      end

      test "is active when they have completed onboarding checklist items" do
        recipient = build(:recipient, signed_terms_at: ~U[2020-01-01T00:00:00Z], met_kaibosh_at: ~U[2020-01-01T00:00:00Z])
        assert Recipient.status(recipient) == :active
      end

      test "is pending if start date is not set" do
        recipient = build(:recipient, started_at: nil)
        assert Recipient.status(recipient) == :pending
      end

      test "is archived if archived at date is set" do
        recipient = build(:recipient, archived_at: ~U[2020-01-01T00:00:00Z])
        assert Recipient.status(recipient) == :archived
      end
    end
  end
