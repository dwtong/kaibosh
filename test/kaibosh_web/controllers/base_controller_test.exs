defmodule KaiboshWeb.BaseControllerTest do
  use KaiboshWeb.ConnCase

  def fixture(:base) do
    insert(:base)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list base for organisation" do
    setup [:create_base]

    test "renders base for organisation", %{conn: conn, base: base} do
      conn = get(conn, Routes.base_path(conn, :index))

      response = List.first(json_response(conn, 200))

      assert response["id"] == base.id
      assert response["name"] == base.name
    end
  end

  defp create_base(_) do
    base = insert(:base)
    %{base: base}
  end
end
