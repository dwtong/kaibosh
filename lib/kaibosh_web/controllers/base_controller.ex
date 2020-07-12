defmodule KaiboshWeb.BaseController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    bases = Organisations.list_bases()
    render(conn, "index.json", bases: bases)
  end
end
