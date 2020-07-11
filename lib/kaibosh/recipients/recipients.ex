defmodule Kaibosh.Recipients do
  @moduledoc """
  The Recipients context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.Recipients.Recipient

  def list_recipients do
    Repo.all(Recipient)
  end

  def get_recipient!(id) do
    Recipient
    |> where(id: ^id)
    |> join(:left, [r], c in assoc(r, :contact))
    |> preload(:contact)
    |> Repo.one!()
  end

  def create_recipient(attrs \\ %{}) do
    %Recipient{}
    |> Repo.preload(:contact)
    |> Recipient.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipient(%Recipient{} = recipient, attrs) do
    recipient
    |> Repo.preload(:contact)
    |> Recipient.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipient(%Recipient{} = recipient) do
    Repo.delete(recipient)
  end

  def archive_recipient(%Recipient{} = recipient) do
    recipient
    |> update_recipient(%{archived_at: DateTime.utc_now()})
  end

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end
end
