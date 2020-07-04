defmodule KaiboshWeb.StaffControllerTest do
  use KaiboshWeb.ConnCase

  def fixture(:staff) do
    insert(:staff)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list staff for organisation" do
    setup [:create_staff]

    test "renders staff for organisation", %{conn: conn, staff: staff, org: org} do
      conn = get(conn, Routes.organisation_staff_path(conn, :index, org.id))

      response = List.first(json_response(conn, 200)["data"])

      assert response["id"] == staff.id
      assert response["first_name"] == staff.first_name
      assert response["last_name"] == staff.last_name
    end

    test "excludes staff from other organisations", %{conn: conn, staff: staff, org: org} do
      other_staff = insert(:staff)
      conn = get(conn, Routes.organisation_staff_path(conn, :index, org.id))

      response = json_response(conn, 200)["data"]

      assert length(response) == 1
      assert Enum.find(response, fn %{"id" => id} -> id == staff.id end)
      refute Enum.find(response, fn %{"id" => id} -> id == other_staff.id end)
    end
  end

  defp create_staff(_) do
    organisation = insert(:organisation)
    base = insert(:base, organisation: organisation)
    staff = insert(:staff, base: base)
    %{staff: staff, org: organisation, base: base}
  end
end
