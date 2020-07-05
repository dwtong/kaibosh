defmodule KaiboshWeb.Admin.AllocationCategoryView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.AllocationCategoryView

  def render("index.json", %{allocation_categories: allocation_categories}) do
    %{
      data: render_many(allocation_categories, AllocationCategoryView, "allocation_category.json")
    }
  end

  def render("show.json", %{allocation_category: allocation_category}) do
    %{data: render_one(allocation_category, AllocationCategoryView, "allocation_category.json")}
  end

  def render("allocation_category.json", %{allocation_category: allocation_category}) do
    %{id: allocation_category.id, name: allocation_category.name, unit: allocation_category.unit}
  end
end
