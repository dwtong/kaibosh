defmodule KaiboshWeb.Admin.BaseControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.Organisations.Base

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_base]

    test "lists all bases", %{conn: conn, base: expected_base} do
      conn = get(conn, Routes.base_path(conn, :index))

      assert [base] = json_response(conn, 200)

      assert Map.keys(base) == ~w(id name)
      assert base["id"] == expected_base.id
      assert base["name"] == expected_base.name
    end
  end

  describe "create base" do
    test "renders base when data is valid", %{conn: conn} do
      org = insert(:organisation)
      attrs = Map.put(@create_attrs, :organisation_id, org.id)
      conn = post(conn, Routes.base_path(conn, :create), base: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.base_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.base_path(conn, :create), base: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update base" do
    setup [:create_base]

    test "renders base when data is valid", %{conn: conn, base: %Base{id: id} = base} do
      conn = put(conn, Routes.base_path(conn, :update, base), base: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.base_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, base: base} do
      conn = put(conn, Routes.base_path(conn, :update, base), base: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete base" do
    setup [:create_base]

    test "deletes chosen base", %{conn: conn, base: base} do
      conn = delete(conn, Routes.base_path(conn, :delete, base))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.base_path(conn, :show, base))
      end
    end
  end

  defp create_base(_) do
    base = insert(:base)
    %{base: base}
  end
end
