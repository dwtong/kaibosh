defmodule KaiboshWeb.Admin.AllocationCategoryControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations.AllocationCategory

  @create_attrs %{
    name: "some name",
    unit: "some unit"
  }
  @update_attrs %{
    name: "some updated name",
    unit: "some updated unit"
  }
  @invalid_attrs %{name: nil, unit: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all allocation_categories", %{conn: conn} do
      conn = get(conn, Routes.allocation_category_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create allocation_category" do
    test "renders allocation_category when data is valid", %{conn: conn} do
      organisation = insert(:organisation)
      attrs = Map.put(@create_attrs, :organisation_id, organisation.id)

      conn =
        post(conn, Routes.allocation_category_path(conn, :create), allocation_category: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.allocation_category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "unit" => "some unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.allocation_category_path(conn, :create),
          allocation_category: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update allocation_category" do
    setup [:create_allocation_category]

    test "renders allocation_category when data is valid", %{
      conn: conn,
      allocation_category: %AllocationCategory{id: id} = allocation_category
    } do
      conn =
        put(conn, Routes.allocation_category_path(conn, :update, allocation_category),
          allocation_category: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.allocation_category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "unit" => "some updated unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      allocation_category: allocation_category
    } do
      conn =
        put(conn, Routes.allocation_category_path(conn, :update, allocation_category),
          allocation_category: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete allocation_category" do
    setup [:create_allocation_category]

    test "deletes chosen allocation_category", %{
      conn: conn,
      allocation_category: allocation_category
    } do
      conn = delete(conn, Routes.allocation_category_path(conn, :delete, allocation_category))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.allocation_category_path(conn, :show, allocation_category))
      end
    end
  end

  defp create_allocation_category(_) do
    allocation_category = insert(:allocation_category)
    %{allocation_category: allocation_category}
  end
end
