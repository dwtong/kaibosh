defmodule KaiboshWeb.OrganisationControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations

  @create_attrs %{
    name: "some name"
  }

  def fixture(:organisation) do
    {:ok, organisation} = Organisations.create_organisation(@create_attrs)
    organisation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show organisation" do
    setup [:create_organisation]

    test "renders organisation", %{conn: conn, organisation: %{id: id, name: name}} do
      conn = get(conn, Routes.organisation_path(conn, :show, id))
      response = json_response(conn, 200)["data"]

      assert response["id"] == id
      assert response["name"] == name
    end
  end

  defp create_organisation(_) do
    organisation = fixture(:organisation)
    %{organisation: organisation}
  end
end
