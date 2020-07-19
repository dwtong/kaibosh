defmodule Kaibosh.RecipientSessions do
  @moduledoc """
  The RecipientSessions context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession
  alias Kaibosh.RecipientSessions.Status

  def list_sessions_for_recipient(recipient_id) do
    RecipientSession
    |> where(recipient_id: ^recipient_id)
    |> preload([:allocations, :holds, :session])
    |> Repo.all()
    |> Enum.map(&Status.put/1)
  end

  def get_session!(id) do
    RecipientSession
    |> where(id: ^id)
    |> preload([:allocations, :holds, :session])
    |> Repo.one!()
    |> Status.put()
  end

  def create_session(attrs \\ %{}) do
    %RecipientSession{}
    |> RecipientSession.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, session} -> {:ok, Repo.preload(session, [:allocations, :holds, :session])}
      error -> error
    end
  end

  def update_session(%RecipientSession{} = recipient_session, attrs) do
    recipient_session
    |> Repo.preload([:allocations, :holds, :session])
    |> RecipientSession.changeset(attrs)
    |> Repo.update()
  end

  def delete_session(%RecipientSession{} = recipient_session) do
    Repo.delete(recipient_session)
  end

  def change_session(%RecipientSession{} = recipient_session, attrs \\ %{}) do
    RecipientSession.changeset(recipient_session, attrs)
  end

  def get_hold_for_recipient!(hold_id, recipient_id) do
    Hold
    |> join(:inner, [h], rs in assoc(h, :recipient_session))
    |> where([h, rs], rs.recipient_id == ^recipient_id and h.id == ^hold_id)
    |> Repo.one!()
  end

  def create_hold(attrs \\ %{}) do
    %Hold{}
    |> Hold.changeset(attrs)
    |> Repo.insert()
  end

  def delete_hold(%Hold{} = hold) do
    Repo.delete(hold)
  end
end
