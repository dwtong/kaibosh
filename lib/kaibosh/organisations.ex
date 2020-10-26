defmodule Kaibosh.Organisations do
  @moduledoc """
  The Organisations context.
  """
  import Kaibosh.Organisations.Query
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Organisations.Category
  alias Kaibosh.Organisations.Organisation
  alias Kaibosh.Organisations.Staff
  alias Kaibosh.Repo
  alias KaiboshWeb.Email

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
    org_id
    |> get_base_by_org_id()
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

  def new_signup_notification(%{base_id: base_id} = recipient) do
    base_id
    |> get_base_notification_emails()
    |> Repo.all()
    |> Email.new_signup_email(recipient)
  end

  def list_staff do
    Repo.all(Staff)
  end

  def list_staff_for_org(org_id) do
    org_id
    |> get_staff_by_org_id()
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

  def list_categories do
    Category
    |> Repo.all()
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
