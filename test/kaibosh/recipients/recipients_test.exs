defmodule Kaibosh.RecipientsTest do
  use Kaibosh.DataCase

  alias Kaibosh.Recipients

  describe "recipients" do
    alias Kaibosh.Recipients.Recipient

    @valid_attrs %{name: "Recipient Org", contact: %{name: "Jenny Smith"}}
    @update_attrs %{name: "Updated name", contact: %{name: "New contact name"}}
    @invalid_attrs %{name: nil}

    test "list_recipients/0 returns all recipients" do
      recipient = insert(:recipient) |> Repo.forget(:base)
      assert Recipients.list_recipients() == [recipient]
    end

    test "get_recipient!/1 returns the recipient and contact with given id" do
      expected_recipient = insert(:recipient, contact: insert(:contact)) |> Repo.forget(:base)
      recipient = Recipients.get_recipient!(expected_recipient.id)
      assert expected_recipient.name == recipient.name
      assert expected_recipient.contact.name == recipient.contact.name
    end

    test "create_recipient/1 with valid data creates a recipient with a contact" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)
      assert {:ok, %Recipient{} = recipient} = Recipients.create_recipient(attrs)
      assert recipient.name == "Recipient Org"
      assert recipient.contact.name == "Jenny Smith"
    end

    test "create_recipient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipients.create_recipient(@invalid_attrs)
    end

    test "update_recipient/2 with valid data updates the recipient with a contact" do
      recipient = insert(:recipient) |> Repo.forget(:base)

      assert {:ok, %Recipient{} = recipient} =
               Recipients.update_recipient(recipient, @update_attrs)

      assert recipient.name == "Updated name"
      assert recipient.contact.name == "New contact name"
    end

    test "update_recipient/2 with invalid data returns error changeset" do
      recipient = insert(:recipient) |> Repo.forget([:base])
      assert {:error, %Ecto.Changeset{}} = Recipients.update_recipient(recipient, @invalid_attrs)
      assert Recipients.get_recipient!(recipient.id) == recipient |> Repo.preload(:contact)
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
