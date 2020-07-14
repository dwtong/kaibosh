defmodule Kaibosh.RecipientSessions do
  @moduledoc """
  The RecipientSessions context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.RecipientSessions.Hold
  alias Kaibosh.RecipientSessions.RecipientSession

  def list_sessions do
    RecipientSession
    |> preload([:holds, :allocations])
    |> Repo.all()
  end

  def get_session!(id) do
    RecipientSession
    |> where(id: ^id)
    |> preload([:holds, :allocations])
    |> Repo.one!()
  end

  def create_session(attrs \\ %{}) do
    %RecipientSession{}
    |> RecipientSession.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, session} -> {:ok, Repo.preload(session, [:allocations, :holds])}
      error -> error
    end
  end

  def update_session(%RecipientSession{} = recipient_session, attrs) do
    recipient_session
    |> Repo.preload([:allocations, :holds])
    |> RecipientSession.changeset(attrs)
    |> Repo.update()
  end

  def delete_session(%RecipientSession{} = recipient_session) do
    Repo.delete(recipient_session)
  end

  def change_session(%RecipientSession{} = recipient_session, attrs \\ %{}) do
    RecipientSession.changeset(recipient_session, attrs)
  end

  def get_hold!(id), do: Repo.get!(Hold, id)

  def create_hold(attrs \\ %{}) do
    %Hold{}
    |> Hold.changeset(attrs)
    |> Repo.insert()
  end

  def delete_hold(%Hold{} = hold) do
    Repo.delete(hold)
  end
end
