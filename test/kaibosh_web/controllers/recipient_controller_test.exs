defmodule KaiboshWeb.RecipientControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Recipients.Recipient

  @create_attrs %{name: "Test Recipient", contact: %{name: "Henry Harrison"}}
  @update_attrs %{
    name: "Updated Recipient",
    has_signed_terms: false,
    has_met_kaibosh: true,
    contact: %{name: "Updated contact name"}
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list recipients" do
    setup [:create_recipient]

    test "lists recipients with the correct attrs", %{conn: conn, recipient: expected_recipient} do
      conn = get(conn, Routes.recipient_path(conn, :index))

      assert [recipient] = json_response(conn, 200)
      assert Map.keys(recipient) == ~w(base_id id name status)

      assert recipient["id"] == expected_recipient.id
      assert recipient["name"] == expected_recipient.name
      assert recipient["base_id"] == expected_recipient.base_id
      assert recipient["status"] == "pending"
    end
  end

  describe "show recipient" do
    setup [:create_recipient]

    test "shows recipient with the correct attrs", %{conn: conn, recipient: expected_recipient} do
      conn = get(conn, Routes.recipient_path(conn, :show, expected_recipient.id))

      assert recipient = json_response(conn, 200)

      assert Map.keys(recipient) ==
               ~w(base_id contact description has_met_kaibosh has_signed_terms id name physical_address started_at status)

      assert Map.keys(recipient["contact"]) == ~w(email name phone_landline phone_mobile)

      assert recipient["id"] == expected_recipient.id
      assert recipient["name"] == expected_recipient.name
      assert recipient["base_id"] == expected_recipient.base_id
      assert recipient["status"] == "pending"
      assert recipient["has_met_kaibosh"] == true
      assert recipient["has_signed_terms"] == true
      assert recipient["started_at"] == DateTime.to_iso8601(expected_recipient.started_at)
    end
  end

  describe "create recipient" do
    test "renders recipient when data is valid", %{conn: conn} do
      base = insert(:base)
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.recipient_path(conn, :create), recipient: attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.recipient_path(conn, :show, id))

      assert recipient = json_response(conn, 200)
      assert recipient["name"] == @create_attrs.name
      assert recipient["contact"]["name"] == @create_attrs.contact.name
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
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.recipient_path(conn, :show, id))

      assert recipient = json_response(conn, 200)
      assert recipient["name"] == @update_attrs.name
      assert recipient["has_signed_terms"] == false
      assert recipient["has_met_kaibosh"] == true
      assert recipient["contact"]["name"] == @update_attrs.contact.name
    end

    test "renders errors when data is invalid", %{conn: conn, recipient: recipient} do
      conn = put(conn, Routes.recipient_path(conn, :update, recipient), recipient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete recipient" do
    setup [:create_recipient]

    test "archives chosen recipient", %{conn: conn, recipient: recipient} do
      conn = delete(conn, Routes.recipient_path(conn, :delete, recipient))
      assert recipient = json_response(conn, 200)
      assert recipient["status"] == "archived"
    end
  end

  defp create_recipient(_) do
    recipient = insert(:recipient, signed_terms_at: ~U[2020-01-01T00:00:00Z])
    contact = insert(:contact, recipient: recipient)
    %{recipient: contact.recipient, contact: contact}
  end
end
