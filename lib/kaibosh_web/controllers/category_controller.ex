defmodule KaiboshWeb.CategoryController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, %{"base_id" => base_id}) do
    categories = Organisations.list_categories_for_base(base_id)
    render(conn, "index.json", categories: categories)
  end
end
