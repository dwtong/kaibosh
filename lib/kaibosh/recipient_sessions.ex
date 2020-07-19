defmodule Kaibosh.RecipientSessions do
  @moduledoc """
  The RecipientSessions context.
  """

  import Kaibosh.RecipientSessions.Query

  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession
  alias Kaibosh.RecipientSessions.Status
  alias Kaibosh.Repo

  def list_sessions_for_recipient(recipient_id) do
    recipient_id
    |> get_sessions_for_recipient()
    |> Repo.all()
    |> Enum.map(&Status.put/1)
  end

  def get_session!(recipient_session_id) do
    recipient_session_id
    |> get_session_by_id()
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
    hold_id
    |> get_hold_by_id_and_recipient_id(recipient_id)
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
