defmodule KaiboshWeb.Admin.ContactControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Recipients.Contact

  @create_attrs %{name: "Contact name"}
  @update_attrs %{name: "Updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:contact) do
    insert(:contact)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create contact" do
    test "renders contact when data is valid", %{conn: conn} do
      recipient = insert(:recipient)
      attrs = Map.put(@create_attrs, :recipient_id, recipient.id)
      path = Routes.contact_path(conn, :create)
      conn = post(conn, path, contact: attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.contact_path(conn, :show, id))

      assert %{"id" => id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      path = Routes.contact_path(conn, :create)
      conn = post(conn, path, contact: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "renders contact when data is valid", %{conn: conn, contact: %Contact{id: id} = contact} do
      path = Routes.contact_path(conn, :update, contact)
      conn = put(conn, path, contact: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.contact_path(conn, :show, id))

      assert %{"id" => id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      path = Routes.contact_path(conn, :update, contact)
      conn = put(conn, path, contact: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete(conn, Routes.contact_path(conn, :delete, contact))

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.contact_path(conn, :show, contact))
      end
    end
  end

  defp create_contact(_) do
    contact = insert(:contact)
    %{contact: contact}
  end
end
