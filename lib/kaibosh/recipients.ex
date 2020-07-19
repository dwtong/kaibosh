defmodule Kaibosh.Recipients do
  @moduledoc """
  The Recipients context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.Recipients.Recipient
  alias Kaibosh.Recipients.Status

  def list_recipients do
    Status.recipient_with_status_query()
    |> Repo.all()
    |> Enum.map(&Status.put/1)
  end

  def get_recipient!(id) do
    Status.recipient_with_status_query()
    |> where(id: ^id)
    |> join(:left, [r], c in assoc(r, :contact))
    |> preload(:contact)
    |> Repo.one!()
    |> Status.put()
  end

  def create_recipient(attrs \\ %{}) do
    %Recipient{}
    |> Repo.preload(:contact)
    |> Recipient.changeset(attrs)
    |> Repo.insert()
    |> Status.put()
  end

  def update_recipient(%Recipient{} = recipient, attrs) do
    recipient
    |> Repo.preload(:contact)
    |> Recipient.changeset(attrs)
    |> Repo.update()
    |> Status.put()
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
