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

    test "renders base for organisation", %{conn: conn, base: base, org: org} do
      conn = get(conn, Routes.organisation_base_path(conn, :index, org.id))

      response = List.first(json_response(conn, 200)["data"])

      assert response["id"] == base.id
      assert response["name"] == base.name
    end

    test "excludes base from other organisations", %{conn: conn, base: base, org: org} do
      other_base = insert(:base)
      conn = get(conn, Routes.organisation_base_path(conn, :index, org.id))

      response = json_response(conn, 200)["data"]

      assert length(response) == 1
      assert Enum.find(response, fn %{"id" => id} -> id == base.id end)
      refute Enum.find(response, fn %{"id" => id} -> id == other_base.id end)
    end
  end

  defp create_base(_) do
    organisation = insert(:organisation)
    base = insert(:base, organisation: organisation)
    %{base: base, org: organisation}
  end
end
