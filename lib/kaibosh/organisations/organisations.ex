defmodule Kaibosh.Organisations do
  @moduledoc """
  The Organisations context.
  """

  import Ecto.Query, warn: false
  alias Kaibosh.Repo

  alias Kaibosh.Organisations.Base
  alias Kaibosh.Organisations.Organisation
  alias Kaibosh.Organisations.Staff

  def list_organisations do
    Repo.all(Organisation)
  end

  def get_organisation!(id), do: Repo.get!(Organisation, id)

  def create_organisation(attrs \\ %{}) do
    %Organisation{}
    |> Organisation.changeset(attrs)
    |> Repo.insert()
  end

  def update_organisation(%Organisation{} = organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  def delete_organisation(%Organisation{} = organisation) do
    Repo.delete(organisation)
  end

  def change_organisation(%Organisation{} = organisation, attrs \\ %{}) do
    Organisation.changeset(organisation, attrs)
  end

  def list_bases do
    Repo.all(Base)
  end

  def list_bases_for_org(org_id) do
    Base
    |> where(organisation_id: ^org_id)
    |> Repo.all()
  end

  def get_base!(id), do: Repo.get!(Base, id)

  def create_base(attrs \\ %{}) do
    %Base{}
    |> Base.changeset(attrs)
    |> Repo.insert()
  end

  def update_base(%Base{} = base, attrs) do
    base
    |> Base.changeset(attrs)
    |> Repo.update()
  end

  def delete_base(%Base{} = base) do
    Repo.delete(base)
  end

  def change_base(%Base{} = base, attrs \\ %{}) do
    Base.changeset(base, attrs)
  end

  def list_staff do
    Repo.all(Staff)
  end

  def list_staff_for_org(org_id) do
    Staff
    |> join(:inner, [s], b in assoc(s, :base))
    |> where([s, b], b.organisation_id == ^org_id)
    |> Repo.all()
  end

  def get_staff!(id), do: Repo.get!(Staff, id)

  def create_staff(attrs \\ %{}) do
    %Staff{}
    |> Staff.changeset(attrs)
    |> Repo.insert()
  end

  def update_staff(%Staff{} = staff, attrs) do
    staff
    |> Staff.changeset(attrs)
    |> Repo.update()
  end

  def delete_staff(%Staff{} = staff) do
    Repo.delete(staff)
  end

  def change_staff(%Staff{} = staff, attrs \\ %{}) do
    Staff.changeset(staff, attrs)
  end

  alias Kaibosh.Organisations.AllocationCategory

  @doc """
  Returns the list of allocation_categories.

  ## Examples

      iex> list_allocation_categories()
      [%AllocationCategory{}, ...]

  """
  def list_allocation_categories do
    Repo.all(AllocationCategory)
  end

  @doc """
  Gets a single allocation_category.

  Raises `Ecto.NoResultsError` if the Allocation category does not exist.

  ## Examples

      iex> get_allocation_category!(123)
      %AllocationCategory{}

      iex> get_allocation_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_allocation_category!(id), do: Repo.get!(AllocationCategory, id)

  @doc """
  Creates a allocation_category.

  ## Examples

      iex> create_allocation_category(%{field: value})
      {:ok, %AllocationCategory{}}

      iex> create_allocation_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_allocation_category(attrs \\ %{}) do
    %AllocationCategory{}
    |> AllocationCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a allocation_category.

  ## Examples

      iex> update_allocation_category(allocation_category, %{field: new_value})
      {:ok, %AllocationCategory{}}

      iex> update_allocation_category(allocation_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_allocation_category(%AllocationCategory{} = allocation_category, attrs) do
    allocation_category
    |> AllocationCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a allocation_category.

  ## Examples

      iex> delete_allocation_category(allocation_category)
      {:ok, %AllocationCategory{}}

      iex> delete_allocation_category(allocation_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_allocation_category(%AllocationCategory{} = allocation_category) do
    Repo.delete(allocation_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking allocation_category changes.

  ## Examples

      iex> change_allocation_category(allocation_category)
      %Ecto.Changeset{data: %AllocationCategory{}}

  """
  def change_allocation_category(%AllocationCategory{} = allocation_category, attrs \\ %{}) do
    AllocationCategory.changeset(allocation_category, attrs)
  end
end
