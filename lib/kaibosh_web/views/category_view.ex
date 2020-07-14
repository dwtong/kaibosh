defmodule KaiboshWeb.CategoryView do
  use KaiboshWeb, :view
  alias KaiboshWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    render_many(categories, CategoryView, "category.json")
  end

  def render("category.json", %{category: category}) do
    %{id: category.id, name: category.name, unit: category.unit}
  end
end
