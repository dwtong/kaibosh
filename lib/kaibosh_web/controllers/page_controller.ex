defmodule KaiboshWeb.PageController do
  use KaiboshWeb, :controller

  # sobelow_skip ["Traversal.SendFile"]
  def index(conn, _params) do
    render(conn, :home, layout: false)
    # |> put_resp_header("content-type", "text/html; charset=utf-8")
    # |> Plug.Conn.send_file(200, file)
    # |> halt()
  end
end
