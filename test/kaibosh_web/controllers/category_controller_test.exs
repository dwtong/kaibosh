defmodule KaiboshWeb.CategoryControllerTest do
  use KaiboshWeb.ConnCase

  describe "index" do
    setup [:create_category]

    test "lists all categories", %{conn: conn, category: expected_category} do
      conn = get(conn, Routes.category_path(conn, :index))

      assert [category] = json_response(conn, 200)
      assert Map.keys(category) == ~w(id image_name name unit)
      assert category["id"] == expected_category.id
      assert category["name"] == expected_category.name
      assert category["unit"] == expected_category.unit
      assert category["image_name"] == expected_category.image_name
    end
  end

  defp create_category(_) do
    category = insert(:category)
    %{category: category}
  end
end
