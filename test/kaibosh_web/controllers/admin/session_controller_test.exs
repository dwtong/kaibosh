defmodule KaiboshWeb.Admin.SessionControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Sessions.Session

  @create_attrs %{
    day: "some day",
    time_in_seconds: 42
  }
  @update_attrs %{
    day: "some updated day",
    time_in_seconds: 43
  }
  @invalid_attrs %{day: nil, time_in_seconds: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create session" do
    test "renders session when data is valid", %{conn: conn} do
      base = insert(:base)
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.session_path(conn, :create), session: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.session_path(conn, :show, id))

      assert %{
               "id" => id,
               "day" => "some day",
               "time_in_seconds" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update session" do
    setup [:create_session]

    test "renders session when data is valid", %{conn: conn, session: %Session{id: id} = session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.session_path(conn, :show, id))

      assert %{
               "id" => id,
               "day" => "some updated day",
               "time_in_seconds" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, session: session} do
      conn = put(conn, Routes.session_path(conn, :update, session), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, Routes.session_path(conn, :delete, session))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.session_path(conn, :show, session))
      end
    end
  end

  defp create_session(_) do
    session = insert(:session)
    %{session: session}
  end
end
