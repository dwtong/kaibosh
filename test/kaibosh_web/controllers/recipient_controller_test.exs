defmodule KaiboshWeb.RecipientControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Recipients.Recipient

  @create_attrs %{name: "Test Recipient"}
  @update_attrs %{name: "Updated Recipient"}
  @invalid_attrs %{name: nil}

  def fixture(:recipient) do
    insert(:recipient)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all recipients", %{conn: conn} do
      conn = get(conn, Routes.recipient_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create recipient" do
    test "renders recipient when data is valid", %{conn: conn} do
      base = insert(:base)
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.recipient_path(conn, :create), recipient: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.recipient_path(conn, :show, id))
      assert %{"id" => id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipient_path(conn, :create), recipient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update recipient" do
    setup [:create_recipient]

    test "renders recipient when data is valid", %{
      conn: conn,
      recipient: %Recipient{id: id} = recipient
    } do
      conn = put(conn, Routes.recipient_path(conn, :update, recipient), recipient: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.recipient_path(conn, :show, id))

      assert %{"id" => id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, recipient: recipient} do
      conn = put(conn, Routes.recipient_path(conn, :update, recipient), recipient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_recipient(_) do
    recipient = fixture(:recipient)
    %{recipient: recipient}
  end
end
