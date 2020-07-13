defmodule Kaibosh.RecipientSessions do
  @moduledoc """
  The RecipientSessions context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.RecipientSessions.RecipientSession

  def list_sessions do
    Repo.all(RecipientSession)
  end

  def get_session!(id), do: Repo.get!(RecipientSession, id)

  def create_session(attrs \\ %{}) do
    %RecipientSession{}
    |> RecipientSession.changeset(attrs)
    |> Repo.insert()
  end

  def update_session(%RecipientSession{} = recipient_session, attrs) do
    recipient_session
    |> RecipientSession.changeset(attrs)
    |> Repo.update()
  end

  def delete_session(%RecipientSession{} = recipient_session) do
    Repo.delete(recipient_session)
  end

  def change_session(%RecipientSession{} = recipient_session, attrs \\ %{}) do
    RecipientSession.changeset(recipient_session, attrs)
  end

  alias Kaibosh.RecipientSessions.Allocation

  @doc """
  Returns the list of allocations.

  ## Examples

      iex> list_allocations()
      [%Allocation{}, ...]

  """
  def list_allocations do
    Repo.all(Allocation)
  end

  @doc """
  Gets a single allocation.

  Raises `Ecto.NoResultsError` if the Allocation does not exist.

  ## Examples

      iex> get_allocation!(123)
      %Allocation{}

      iex> get_allocation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_allocation!(id), do: Repo.get!(Allocation, id)

  @doc """
  Creates a allocation.

  ## Examples

      iex> create_allocation(%{field: value})
      {:ok, %Allocation{}}

      iex> create_allocation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_allocation(attrs \\ %{}) do
    %Allocation{}
    |> Allocation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a allocation.

  ## Examples

      iex> update_allocation(allocation, %{field: new_value})
      {:ok, %Allocation{}}

      iex> update_allocation(allocation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_allocation(%Allocation{} = allocation, attrs) do
    allocation
    |> Allocation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a allocation.

  ## Examples

      iex> delete_allocation(allocation)
      {:ok, %Allocation{}}

      iex> delete_allocation(allocation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_allocation(%Allocation{} = allocation) do
    Repo.delete(allocation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking allocation changes.

  ## Examples

      iex> change_allocation(allocation)
      %Ecto.Changeset{data: %Allocation{}}

  """
  def change_allocation(%Allocation{} = allocation, attrs \\ %{}) do
    Allocation.changeset(allocation, attrs)
  end

  alias Kaibosh.RecipientSessions.Hold

  @doc """
  Returns the list of holds.

  ## Examples

      iex> list_holds()
      [%Hold{}, ...]

  """
  def list_holds do
    Repo.all(Hold)
  end

  @doc """
  Gets a single hold.

  Raises `Ecto.NoResultsError` if the Hold does not exist.

  ## Examples

      iex> get_hold!(123)
      %Hold{}

      iex> get_hold!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hold!(id), do: Repo.get!(Hold, id)

  @doc """
  Creates a hold.

  ## Examples

      iex> create_hold(%{field: value})
      {:ok, %Hold{}}

      iex> create_hold(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hold(attrs \\ %{}) do
    %Hold{}
    |> Hold.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hold.

  ## Examples

      iex> update_hold(hold, %{field: new_value})
      {:ok, %Hold{}}

      iex> update_hold(hold, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hold(%Hold{} = hold, attrs) do
    hold
    |> Hold.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hold.

  ## Examples

      iex> delete_hold(hold)
      {:ok, %Hold{}}

      iex> delete_hold(hold)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hold(%Hold{} = hold) do
    Repo.delete(hold)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hold changes.

  ## Examples

      iex> change_hold(hold)
      %Ecto.Changeset{data: %Hold{}}

  """
  def change_hold(%Hold{} = hold, attrs \\ %{}) do
    Hold.changeset(hold, attrs)
  end
end
