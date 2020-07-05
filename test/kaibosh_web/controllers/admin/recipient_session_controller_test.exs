defmodule KaiboshWeb.Admin.RecipientSessionControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.RecipientSessions.RecipientSession

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{session_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipient_sessions", %{conn: conn} do
      conn = get(conn, Routes.recipient_session_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipient_session" do
    test "renders recipient_session when data is valid", %{conn: conn} do
      session = insert(:session)
      recipient = insert(:recipient)
      attrs = Map.merge(@create_attrs, %{session_id: session.id, recipient_id: recipient.id})
      conn = post(conn, Routes.recipient_session_path(conn, :create), recipient_session: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipient_session_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.recipient_session_path(conn, :create), recipient_session: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipient_session" do
    setup [:create_recipient_session]

    test "renders recipient_session when data is valid", %{
      conn: conn,
      recipient_session: %RecipientSession{id: id} = recipient_session
    } do
      conn =
        put(conn, Routes.recipient_session_path(conn, :update, recipient_session),
          recipient_session: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.recipient_session_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      recipient_session: recipient_session
    } do
      conn =
        put(conn, Routes.recipient_session_path(conn, :update, recipient_session),
          recipient_session: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipient_session" do
    setup [:create_recipient_session]

    test "deletes chosen recipient_session", %{conn: conn, recipient_session: recipient_session} do
      conn = delete(conn, Routes.recipient_session_path(conn, :delete, recipient_session))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.recipient_session_path(conn, :show, recipient_session))
      end
    end
  end

  defp create_recipient_session(_) do
    recipient_session = insert(:recipient_session)
    %{recipient_session: recipient_session}
  end
end
