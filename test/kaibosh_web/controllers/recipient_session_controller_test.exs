defmodule KaiboshWeb.RecipientSessionControllerTest do
  use KaiboshWeb.ConnCase

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{session_id: nil}

  describe "index" do
    setup [:create_session]

    test "lists all recipient_sessions", %{conn: conn, recipient_session: expected_session} do
      conn = get(conn, route(conn, :index, expected_session.recipient.id))

      assert [session] = json_response(conn, 200)
      assert Map.keys(session) == ~w(id)
      assert session["id"] == expected_session.id
    end
  end

  describe "create recipient_session" do
    test "renders recipient_session when data is valid", %{conn: conn} do
      session = insert(:session)
      %{id: recipient_id} = insert(:recipient)
      attrs = Map.merge(@create_attrs, %{session_id: session.id, recipient_id: recipient_id})

      conn = post(conn, route(conn, :create, recipient_id), session: attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, route(conn, :show, recipient_id, id))
      assert %{"id" => id} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      recipient = insert(:recipient)
      conn = post(conn, route(conn, :create, recipient.id), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipient_session" do
    setup [:create_session]

    test "renders recipient_session when data is valid", %{
      conn: conn,
      recipient_session: %{id: id, recipient_id: recipient_id}
    } do
      conn = put(conn, route(conn, :update, recipient_id, id), session: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, route(conn, :show, recipient_id, id))
      assert %{"id" => id} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      recipient_session: %{id: id, recipient_id: recipient_id}
    } do
      conn = put(conn, route(conn, :update, recipient_id, id), session: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipient_session" do
    setup [:create_session]

    test "deletes chosen recipient_session", %{
      conn: conn,
      recipient_session: %{id: id, recipient_id: recipient_id}
    } do
      conn = delete(conn, route(conn, :delete, recipient_id, id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, route(conn, :show, recipient_id, id))
      end
    end
  end

  defp create_session(_) do
    recipient_session = insert(:recipient_session)
    %{recipient_session: recipient_session}
  end

  defp route(conn, action, recipient_id) do
    Routes.recipient_recipient_session_path(conn, action, recipient_id)
  end

  defp route(conn, action, recipient_id, id) do
    Routes.recipient_recipient_session_path(conn, action, recipient_id, id)
  end
end
