defmodule KaiboshWeb.Admin.StaffControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations.Staff

  @create_attrs %{
    first_name: "some first_name",
    last_name: "some last_name"
  }
  @update_attrs %{
    first_name: "some updated first_name",
    last_name: "some updated last_name"
  }
  @invalid_attrs %{first_name: nil, last_name: nil}

  def fixture(:staff) do
    insert(:staff)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all staff", %{conn: conn} do
      conn = get(conn, Routes.staff_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create staff" do
    test "renders staff when data is valid", %{conn: conn} do
      base = insert(:base)
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.staff_path(conn, :create), staff: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.staff_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "first_name" => "some first_name",
               "last_name" => "some last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.staff_path(conn, :create), staff: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update staff" do
    setup [:create_staff]

    test "renders staff when data is valid", %{conn: conn, staff: %Staff{id: id} = staff} do
      conn = put(conn, Routes.staff_path(conn, :update, staff), staff: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.staff_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, staff: staff} do
      conn = put(conn, Routes.staff_path(conn, :update, staff), staff: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete staff" do
    setup [:create_staff]

    test "deletes chosen staff", %{conn: conn, staff: staff} do
      conn = delete(conn, Routes.staff_path(conn, :delete, staff))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.staff_path(conn, :show, staff))
      end
    end
  end

  defp create_staff(_) do
    staff = fixture(:staff)
    %{staff: staff}
  end
end
