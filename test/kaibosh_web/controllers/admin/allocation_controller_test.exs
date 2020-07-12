defmodule KaiboshWeb.Admin.AllocationControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.RecipientSessions.Allocation

  @create_attrs %{
    quantity: "120.5"
  }
  @update_attrs %{
    quantity: "456.7"
  }
  @invalid_attrs %{category_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all allocations", %{conn: conn} do
      conn = get(conn, Routes.allocation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create allocation" do
    test "renders allocation when data is valid", %{conn: conn} do
      recipient_session = insert(:recipient_session)
      category = insert(:category)

      attrs =
        Map.merge(
          @create_attrs,
          %{
            recipient_session_id: recipient_session.id,
            category_id: category.id
          }
        )

      conn = post(conn, Routes.allocation_path(conn, :create), allocation: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.allocation_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.allocation_path(conn, :create), allocation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update allocation" do
    setup [:create_allocation]

    test "renders allocation when data is valid", %{
      conn: conn,
      allocation: %Allocation{id: id} = allocation
    } do
      conn =
        put(conn, Routes.allocation_path(conn, :update, allocation), allocation: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.allocation_path(conn, :show, id))

      assert %{
               "id" => id,
               "quantity" => "456.7"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, allocation: allocation} do
      conn =
        put(conn, Routes.allocation_path(conn, :update, allocation), allocation: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete allocation" do
    setup [:create_allocation]

    test "deletes chosen allocation", %{conn: conn, allocation: allocation} do
      conn = delete(conn, Routes.allocation_path(conn, :delete, allocation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.allocation_path(conn, :show, allocation))
      end
    end
  end

  defp create_allocation(_) do
    allocation = insert(:allocation)
    %{allocation: allocation}
  end
end
