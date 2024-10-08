defmodule KaiboshWeb.Admin.OrganisationControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Organisation

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:organisation) do
    {:ok, organisation} = Organisations.create_organisation(@create_attrs)
    organisation
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all organisations", %{conn: conn} do
      conn = get(conn, Routes.organisation_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create organisation" do
    test "renders organisation when data is valid", %{conn: conn} do
      conn = post(conn, Routes.organisation_path(conn, :create), organisation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.organisation_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.organisation_path(conn, :create), organisation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update organisation" do
    setup [:create_organisation]

    test "renders organisation when data is valid", %{
      conn: conn,
      organisation: %Organisation{id: id} = organisation
    } do
      conn =
        put(conn, Routes.organisation_path(conn, :update, organisation),
          organisation: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.organisation_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, organisation: organisation} do
      conn =
        put(conn, Routes.organisation_path(conn, :update, organisation),
          organisation: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete organisation" do
    setup [:create_organisation]

    test "deletes chosen organisation", %{conn: conn, organisation: organisation} do
      conn = delete(conn, Routes.organisation_path(conn, :delete, organisation))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.organisation_path(conn, :show, organisation))
      end
    end
  end

  defp create_organisation(_) do
    organisation = fixture(:organisation)
    %{organisation: organisation}
  end
end
