defmodule KaiboshWeb.CategoryController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    categories = Organisations.list_categories()
    render(conn, "index.json", categories: categories)
  end
end
