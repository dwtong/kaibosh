defmodule Kaibosh.OrganisationsTest do
  use Kaibosh.DataCase

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Organisations.Organisation
  alias Kaibosh.Organisations.Staff

  describe "organisations" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def organisation_fixture(attrs \\ %{}) do
      {:ok, organisation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organisations.create_organisation()

      organisation
    end

    test "list_organisations/0 returns all organisations" do
      organisation = organisation_fixture()
      assert Organisations.list_organisations() == [organisation]
    end

    test "get_organisation!/1 returns the organisation with given id" do
      organisation = organisation_fixture()
      assert Organisations.get_organisation!(organisation.id) == organisation
    end

    test "create_organisation/1 with valid data creates a organisation" do
      assert {:ok, %Organisation{} = organisation} =
               Organisations.create_organisation(@valid_attrs)

      assert organisation.name == "some name"
    end

    test "create_organisation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_organisation(@invalid_attrs)
    end

    test "update_organisation/2 with valid data updates the organisation" do
      organisation = organisation_fixture()

      assert {:ok, %Organisation{} = organisation} =
               Organisations.update_organisation(organisation, @update_attrs)

      assert organisation.name == "some updated name"
    end

    test "update_organisation/2 with invalid data returns error changeset" do
      organisation = organisation_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Organisations.update_organisation(organisation, @invalid_attrs)

      assert Organisations.get_organisation!(organisation.id) == organisation
    end

    test "delete_organisation/1 deletes the organisation" do
      organisation = organisation_fixture()
      assert {:ok, %Organisation{}} = Organisations.delete_organisation(organisation)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_organisation!(organisation.id) end
    end

    test "change_organisation/1 returns a organisation changeset" do
      organisation = organisation_fixture()
      assert %Ecto.Changeset{} = Organisations.change_organisation(organisation)
    end
  end

  describe "allocation_categories" do
    alias Kaibosh.Organisations.AllocationCategory

    @valid_attrs %{name: "some name", unit: "some unit"}
    @update_attrs %{name: "some updated name", unit: "some updated unit"}
    @invalid_attrs %{name: nil, unit: nil}

    test "list_allocation_categories/0 returns all allocation_categories" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)
      assert Organisations.list_allocation_categories() == [allocation_category]
    end

    test "get_allocation_category!/1 returns the allocation_category with given id" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)
      assert Organisations.get_allocation_category!(allocation_category.id) == allocation_category
    end

    test "create_allocation_category/1 with valid data creates a allocation_category" do
      organisation = insert(:organisation)
      attrs = Map.put(@valid_attrs, :organisation_id, organisation.id)

      assert {:ok, %AllocationCategory{} = allocation_category} =
               Organisations.create_allocation_category(attrs)

      assert allocation_category.name == "some name"
      assert allocation_category.unit == "some unit"
      assert allocation_category.organisation_id == organisation.id
    end

    test "create_allocation_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Organisations.create_allocation_category(@invalid_attrs)
    end

    test "update_allocation_category/2 with valid data updates the allocation_category" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)

      assert {:ok, %AllocationCategory{} = allocation_category} =
               Organisations.update_allocation_category(allocation_category, @update_attrs)

      assert allocation_category.name == "some updated name"
      assert allocation_category.unit == "some updated unit"
    end

    test "update_allocation_category/2 with invalid data returns error changeset" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)

      assert {:error, %Ecto.Changeset{}} =
               Organisations.update_allocation_category(allocation_category, @invalid_attrs)

      assert allocation_category == Organisations.get_allocation_category!(allocation_category.id)
    end

    test "delete_allocation_category/1 deletes the allocation_category" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)

      assert {:ok, %AllocationCategory{}} =
               Organisations.delete_allocation_category(allocation_category)

      assert_raise Ecto.NoResultsError, fn ->
        Organisations.get_allocation_category!(allocation_category.id)
      end
    end

    test "change_allocation_category/1 returns a allocation_category changeset" do
      allocation_category = insert(:allocation_category) |> Repo.forget(:organisation)
      assert %Ecto.Changeset{} = Organisations.change_allocation_category(allocation_category)
    end
  end

  describe "bases" do
    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_bases/0 returns all bases" do
      base = insert(:base) |> Repo.forget(:organisation)
      assert Organisations.list_bases() == [base]
    end

    test "list_bases_for_org/1 returns bases for organisation" do
      base = insert(:base) |> Repo.forget(:organisation)
      insert(:base)
      result = Organisations.list_bases_for_org(base.organisation_id)
      assert length(result) == 1
      assert List.first(result) == base
    end

    test "get_base!/1 returns the base with given id" do
      base = insert(:base) |> Repo.forget(:organisation)
      assert Organisations.get_base!(base.id) == base
    end

    test "create_base/1 with valid data creates a base" do
      org = insert(:organisation)
      attrs = Map.put(@valid_attrs, :organisation_id, org.id)
      assert {:ok, %Base{} = base} = Organisations.create_base(attrs)
      assert base.name == "some name"
      assert base.organisation_id == org.id
    end

    test "create_base/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_base(@invalid_attrs)
    end

    test "update_base/2 with valid data updates the base" do
      base = insert(:base)
      assert {:ok, %Base{} = base} = Organisations.update_base(base, @update_attrs)
      assert base.name == "some updated name"
    end

    test "update_base/2 with invalid data returns error changeset" do
      base = insert(:base) |> Repo.forget(:organisation)
      assert {:error, %Ecto.Changeset{}} = Organisations.update_base(base, @invalid_attrs)
      assert Organisations.get_base!(base.id) == base
    end

    test "delete_base/1 deletes the base" do
      base = insert(:base)
      assert {:ok, %Base{}} = Organisations.delete_base(base)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_base!(base.id) end
    end

    test "change_base/1 returns a base changeset" do
      base = insert(:base)
      assert %Ecto.Changeset{} = Organisations.change_base(base)
    end
  end

  describe "staff" do
    @valid_attrs %{first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_staff/0 returns all staff" do
      staff = insert(:staff) |> Repo.forget(:base)
      assert Organisations.list_staff() == [staff]
    end

    test "list_staff_for_org/1 returns staff for organisation" do
      org = insert(:organisation)
      base = insert(:base, organisation: org)
      staff = insert(:staff, base: base) |> Repo.forget(:base)
      insert(:staff)
      assert Organisations.list_staff_for_org(org.id) == [staff]
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = insert(:staff) |> Repo.forget(:base)
      assert Organisations.get_staff!(staff.id) == staff
    end

    test "create_staff/1 with valid data creates a staff" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)
      assert {:ok, %Staff{} = staff} = Organisations.create_staff(attrs)
      assert staff.first_name == "some first_name"
      assert staff.last_name == "some last_name"
      assert staff.base_id == base.id
    end

    test "create_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organisations.create_staff(@invalid_attrs)
    end

    test "update_staff/2 with valid data updates the staff" do
      staff = insert(:staff)
      assert {:ok, %Staff{} = staff} = Organisations.update_staff(staff, @update_attrs)
      assert staff.first_name == "some updated first_name"
      assert staff.last_name == "some updated last_name"
    end

    test "update_staff/2 with invalid data returns error changeset" do
      staff = insert(:staff) |> Repo.forget(:base)
      assert {:error, %Ecto.Changeset{}} = Organisations.update_staff(staff, @invalid_attrs)
      assert Organisations.get_staff!(staff.id) == staff
    end

    test "delete_staff/1 deletes the staff" do
      staff = insert(:staff)
      assert {:ok, %Staff{}} = Organisations.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> Organisations.get_staff!(staff.id) end
    end

    test "change_staff/1 returns a staff changeset" do
      staff = insert(:staff)
      assert %Ecto.Changeset{} = Organisations.change_staff(staff)
    end
  end
end
