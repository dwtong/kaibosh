defmodule KaiboshWeb.SignupControllerTest do
  use KaiboshWeb.ConnCase
  alias Kaibosh.Recipients.Recipient

  def fixture(:base) do
    insert(:base)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list base for organisation" do
    setup [:create_base]

    test "renders base for organisation", %{conn: conn, base: base} do
      conn = get(conn, Routes.signup_path(conn, :bases))

      response = List.first(json_response(conn, 200))

      assert response["id"] == base.id
      assert response["name"] == base.name
    end
  end

  describe "create recipient" do
    setup [:create_base]

    @create_attrs %{name: "Test recipient", contact: %{name: "Jenna James"}}
    @invalid_attrs %{name: nil}

    test "renders recipient when data is valid", %{conn: conn, base: base} do
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.signup_path(conn, :create), attrs)

      assert %{"name" => name} = json_response(conn, 201)

      recipient = Repo.one(Recipient) |> Repo.preload(:contact)

      assert recipient.name == @create_attrs.name
      assert recipient.contact.name == @create_attrs.contact.name
      assert !is_nil(recipient.signed_up_at)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipient_path(conn, :create), recipient: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_base(_) do
    base = insert(:base)
    %{base: base}
  end
end
