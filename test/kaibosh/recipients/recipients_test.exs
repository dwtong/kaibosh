defmodule Kaibosh.RecipientsTest do
  use Kaibosh.DataCase

  alias Kaibosh.Recipients
  alias Kaibosh.Recipients.Status

  describe "recipients" do
    alias Kaibosh.Recipients.Recipient

    @valid_attrs %{name: "Recipient Org", contact: %{name: "Jenny Smith"}}
    @update_attrs %{name: "Updated name", contact: %{name: "New contact name"}}
    @invalid_attrs %{name: nil}

    test "list_recipients/0 returns all recipients" do
      recipient = insert(:recipient) |> Repo.forget(:base) |> Status.put()
      assert Recipients.list_recipients() == [recipient]
    end

    test "search_recipients/1 returns recipients with filters" do
      recipient = insert(:recipient) |> Repo.preload(:contact) |> Status.put()

      recipient_2 =
        insert(:recipient, archived_at: now()) |> Repo.preload(:contact) |> Status.put()

      assert Recipients.search_recipients(%{"name" => recipient_2.name}) == [recipient_2]
      assert Recipients.search_recipients(%{"base" => recipient.base_id}) == [recipient]

      assert Recipients.search_recipients(%{"status" => ["pending", "archived"]}) == [
               recipient,
               recipient_2
             ]

      assert Recipients.search_recipients(%{"status" => ["archived"]}) == [recipient_2]
    end

    test "get_recipient!/1 returns the recipient and contact with given id" do
      expected_recipient = insert(:recipient, contact: insert(:contact)) |> Repo.forget(:base)
      recipient = Recipients.get_recipient!(expected_recipient.id)
      assert recipient.name == expected_recipient.name
      assert recipient.contact.name == expected_recipient.contact.name
      assert recipient.status == :pending
    end

    test "create_recipient/1 with valid data creates a recipient with a contact" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)
      assert {:ok, %Recipient{} = recipient} = Recipients.create_recipient(attrs)
      assert recipient.name == "Recipient Org"
      assert recipient.contact.name == "Jenny Smith"
      assert recipient.status == :pending
    end

    test "create_recipient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipients.create_recipient(@invalid_attrs)
    end

    test "create_recipient_signup/1 creates a recipient with signup date" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)

      assert {:ok, %Recipient{signed_up_at: signup_date}} =
               Recipients.create_recipient_signup(attrs)

      assert !is_nil(signup_date)
    end

    test "create_recipient_signup/1 only allows signup attributes" do
      attrs = %{
        name: "Test recip",
        base_id: insert(:base).id,
        signed_terms_at: ~U[2020-01-01T00:00:00Z]
      }

      assert {:ok, %Recipient{signed_terms_at: nil}} = Recipients.create_recipient_signup(attrs)
    end

    test "update_recipient/2 with valid data updates the recipient with a contact" do
      recipient = insert(:recipient) |> Repo.forget(:base)

      assert {:ok, %Recipient{} = recipient} =
               Recipients.update_recipient(recipient, @update_attrs)

      assert recipient.name == "Updated name"
      assert recipient.contact.name == "New contact name"
      assert recipient.status == :pending
    end

    test "archive_recipient/2 marks the recipient as archived" do
      recipient = insert(:recipient)
      assert is_nil(recipient.archived_at)

      assert {:ok, %Recipient{} = recipient} = Recipients.archive_recipient(recipient)
      refute is_nil(recipient.archived_at)
      assert recipient.status == :archived
    end

    test "update_recipient/2 with invalid data returns error changeset" do
      recipient = insert(:recipient) |> Repo.forget([:base])
      assert {:error, %Ecto.Changeset{}} = Recipients.update_recipient(recipient, @invalid_attrs)
      refute is_nil(Recipients.get_recipient!(recipient.id).name)
    end

    test "delete_recipient/1 deletes the recipient" do
      recipient = insert(:recipient) |> Repo.forget(:base)
      assert {:ok, %Recipient{}} = Recipients.delete_recipient(recipient)
      assert_raise Ecto.NoResultsError, fn -> Recipients.get_recipient!(recipient.id) end
    end

    test "change_recipient/1 returns a recipient changeset" do
      recipient = insert(:recipient) |> Repo.forget(:base)
      assert %Ecto.Changeset{} = Recipients.change_recipient(recipient)
    end
  end
end
