defmodule KaiboshWeb.StatusControllerTest do
  use KaiboshWeb.ConnCase

  test "returns 200 with application version", %{conn: conn} do
    version = "qfsa32g"
    Application.put_env(:kaibosh, :version, version)

    conn = get(conn, "/api/status")
    assert %{"version" => ^version} = json_response(conn, 200)
  end
end
