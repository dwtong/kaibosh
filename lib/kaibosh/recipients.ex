defmodule Kaibosh.Recipients do
  @moduledoc """
  The Recipients context.
  """
  import Kaibosh.Recipients.Query

  alias Kaibosh.Recipients.Recipient
  alias Kaibosh.Recipients.Status
  alias Kaibosh.Repo

  def list_recipients do
    get_recipients()
    |> Repo.all()
    |> Enum.map(&Status.put/1)
  end

  def get_recipient!(recipient_id) do
    recipient_id
    |> get_recipient_by_id()
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
