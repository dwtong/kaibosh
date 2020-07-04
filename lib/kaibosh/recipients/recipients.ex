defmodule Kaibosh.Recipients do
  @moduledoc """
  The Recipients context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.Recipients.Recipient
  alias Kaibosh.Recipients.Contact

  def list_recipients do
    Repo.all(Recipient)
  end

  def get_recipient!(id), do: Repo.get!(Recipient, id)

  def create_recipient(attrs \\ %{}) do
    %Recipient{}
    |> Recipient.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipient(%Recipient{} = recipient, attrs) do
    recipient
    |> Recipient.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipient(%Recipient{} = recipient) do
    Repo.delete(recipient)
  end

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def get_contact!(id), do: Repo.get!(Contact, id)

  def list_contacts do
    Repo.all(Contact)
  end

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end
end
