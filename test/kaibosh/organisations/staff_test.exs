defmodule Kaibosh.Organisations.StaffTest do
  use Kaibosh.DataCase

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Staff

  describe "staff" do
    @valid_attrs %{first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{first_name: nil, last_name: nil}

    test "list_staff/0 returns all staff" do
      staff = insert(:staff)
      result = Organisations.list_staff()
      assert length(result) == 1
      assert List.first(result).id == staff.id
    end

    test "list_staff_for_org/1 returns staff for organisation" do
      staff = insert(:staff)
      insert(:staff)
      result = Organisations.list_staff_for_org(staff.base.organisation_id)
      assert length(result) == 1
      assert List.first(result).id == staff.id
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = insert(:staff)
      result = Organisations.get_staff!(staff.id)
      assert result.id == staff.id
      assert result.first_name == staff.first_name
      assert result.last_name == staff.last_name
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
      staff = insert(:staff)
      assert {:error, %Ecto.Changeset{}} = Organisations.update_staff(staff, @invalid_attrs)
      assert staff.id == Organisations.get_staff!(staff.id).id
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
