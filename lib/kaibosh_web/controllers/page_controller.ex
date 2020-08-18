defmodule KaiboshWeb.PageController do
  use KaiboshWeb, :controller

  def index(conn, _params) do
    file = Application.app_dir(:kaibosh, ["priv", "static", "index.html"])

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, file)
    |> halt()
  end
end
