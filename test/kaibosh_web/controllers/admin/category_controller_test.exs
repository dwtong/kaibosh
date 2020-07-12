defmodule KaiboshWeb.Admin.CategoryControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations.Category

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

  describe "create category" do
    test "renders category when data is valid", %{conn: conn} do
      organisation = insert(:organisation)
      attrs = Map.put(@create_attrs, :organisation_id, organisation.id)

      conn = post(conn, Routes.category_path(conn, :create), category: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name",
               "unit" => "some unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.category_path(conn, :create), category: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update category" do
    setup [:create_category]

    test "renders category when data is valid", %{
      conn: conn,
      category: %Category{id: id} = category
    } do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.category_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name",
               "unit" => "some updated unit"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      category: category
    } do
      conn = put(conn, Routes.category_path(conn, :update, category), category: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{
      conn: conn,
      category: category
    } do
      conn = delete(conn, Routes.category_path(conn, :delete, category))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.category_path(conn, :show, category))
      end
    end
  end

  defp create_category(_) do
    category = insert(:category)
    %{category: category}
  end
end
