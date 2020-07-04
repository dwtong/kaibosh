defmodule Kaibosh.Recipients.ContactTest do
  use Kaibosh.DataCase

  alias Kaibosh.Recipients

  describe "contacts" do
    alias Kaibosh.Recipients.Contact

    @valid_attrs %{name: "Test contact"}
    @update_attrs %{name: "Updated name"}
    @invalid_attrs %{name: nil}

    test "list_contacts/0 returns all contacts" do
      contact = insert(:contact) |> Repo.forget(:recipient)
      assert Recipients.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = insert(:contact) |> Repo.forget(:recipient)
      assert Recipients.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      recipient = insert(:recipient)
      attrs = Map.put(@valid_attrs, :recipient_id, recipient.id)
      assert {:ok, %Contact{} = contact} = Recipients.create_contact(attrs)
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipients.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = insert(:contact)
      assert {:ok, %Contact{} = contact} = Recipients.update_contact(contact, @update_attrs)
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = insert(:contact) |> Repo.forget(:recipient)
      assert {:error, %Ecto.Changeset{}} = Recipients.update_contact(contact, @invalid_attrs)
      assert contact == Recipients.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = insert(:contact)
      assert {:ok, %Contact{}} = Recipients.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Recipients.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = insert(:contact)
      assert %Ecto.Changeset{} = Recipients.change_contact(contact)
    end
  end
end
