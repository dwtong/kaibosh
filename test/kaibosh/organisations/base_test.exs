defmodule Kaibosh.Organisations.BaseTest do
  use Kaibosh.DataCase

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Base

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
end
