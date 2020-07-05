defmodule KaiboshWeb.Admin.HoldControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.RecipientSessions.Hold

  @create_attrs %{
    ends_at: ~U[2010-04-17 14:00:00Z],
    starts_at: ~U[2010-04-17 14:00:00Z]
  }
  @update_attrs %{
    ends_at: ~U[2011-05-18 15:01:01Z],
    starts_at: ~U[2011-05-18 15:01:01Z]
  }
  @invalid_attrs %{ends_at: nil, starts_at: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all holds", %{conn: conn} do
      conn = get(conn, Routes.hold_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create hold" do
    test "renders hold when data is valid", %{conn: conn} do
      recipient_session = insert(:recipient_session)
      attrs = Map.put(@create_attrs, :recipient_session_id, recipient_session.id)
      conn = post(conn, Routes.hold_path(conn, :create), hold: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.hold_path(conn, :show, id))

      assert %{
               "id" => id,
               "ends_at" => "2010-04-17T14:00:00Z",
               "starts_at" => "2010-04-17T14:00:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.hold_path(conn, :create), hold: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update hold" do
    setup [:create_hold]

    test "renders hold when data is valid", %{conn: conn, hold: %Hold{id: id} = hold} do
      conn = put(conn, Routes.hold_path(conn, :update, hold), hold: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.hold_path(conn, :show, id))

      assert %{
               "id" => id,
               "ends_at" => "2011-05-18T15:01:01Z",
               "starts_at" => "2011-05-18T15:01:01Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, hold: hold} do
      conn = put(conn, Routes.hold_path(conn, :update, hold), hold: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete hold" do
    setup [:create_hold]

    test "deletes chosen hold", %{conn: conn, hold: hold} do
      conn = delete(conn, Routes.hold_path(conn, :delete, hold))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.hold_path(conn, :show, hold))
      end
    end
  end

  defp create_hold(_) do
    hold = insert(:hold)
    %{hold: hold}
  end
end
