defmodule KaiboshWeb.SignupControllerTest do
  use KaiboshWeb.ConnCase
  use Bamboo.Test
  alias Kaibosh.Accounts
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
    setup [:create_base, :create_user_to_notify]

    @create_attrs %{name: "Test recipient", contact: %{name: "Jenna James"}}
    @invalid_attrs %{name: nil}

    test "renders recipient when data is valid", %{conn: conn, base: base} do
      attrs = Map.put(@create_attrs, :base_id, base.id)
      conn = post(conn, Routes.signup_path(conn, :create), %{recipient: attrs})

      assert %{"name" => name} = json_response(conn, 201)

      recipient = Repo.one(Recipient) |> Repo.preload(:contact)

      assert recipient.name == @create_attrs.name
      assert recipient.contact.name == @create_attrs.contact.name
      assert !is_nil(recipient.signed_up_at)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.recipient_path(conn, :create), %{recipient: @invalid_attrs})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "notifies base staff members", %{conn: conn, base: base, user: user} do
      attrs = Map.put(@create_attrs, :base_id, base.id)
      post(conn, Routes.signup_path(conn, :create), %{recipient: attrs})

      assert_email_delivered_with(%{subject: "New recipient sign up", to: [nil: user.email]})
    end
  end

  defp create_base(_) do
    base = insert(:base)
    %{base: base}
  end

  defp create_user_to_notify(%{base: %{id: base_id}}) do
    user = insert(:user)
    Accounts.subscribe_user_to_base_notifications(user, base_id)

    %{user: user}
  end
end
