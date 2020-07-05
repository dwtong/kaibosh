defmodule KaiboshWeb.Admin.AllocationView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.AllocationView

  def render("index.json", %{allocations: allocations}) do
    %{data: render_many(allocations, AllocationView, "allocation.json")}
  end

  def render("show.json", %{allocation: allocation}) do
    %{data: render_one(allocation, AllocationView, "allocation.json")}
  end

  def render("allocation.json", %{allocation: allocation}) do
    %{id: allocation.id, quantity: allocation.quantity}
  end
end
