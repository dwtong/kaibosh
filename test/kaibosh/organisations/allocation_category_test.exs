defmodule Kaibosh.Organisations.AllocationCategoryTest do
  use Kaibosh.DataCase

  alias Kaibosh.Organisations

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
end
