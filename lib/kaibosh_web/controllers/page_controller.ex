defmodule KaiboshWeb.PageController do
  use KaiboshWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
