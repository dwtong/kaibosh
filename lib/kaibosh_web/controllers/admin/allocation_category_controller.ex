defmodule KaiboshWeb.Admin.AllocationCategoryController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.AllocationCategory

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    allocation_categories = Organisations.list_allocation_categories()
    render(conn, "index.json", allocation_categories: allocation_categories)
  end

  def create(conn, %{"allocation_category" => allocation_category_params}) do
    with {:ok, %AllocationCategory{} = allocation_category} <-
           Organisations.create_allocation_category(allocation_category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.allocation_category_path(conn, :show, allocation_category)
      )
      |> render("show.json", allocation_category: allocation_category)
    end
  end

  def show(conn, %{"id" => id}) do
    allocation_category = Organisations.get_allocation_category!(id)
    render(conn, "show.json", allocation_category: allocation_category)
  end

  def update(conn, %{"id" => id, "allocation_category" => allocation_category_params}) do
    allocation_category = Organisations.get_allocation_category!(id)

    with {:ok, %AllocationCategory{} = allocation_category} <-
           Organisations.update_allocation_category(
             allocation_category,
             allocation_category_params
           ) do
      render(conn, "show.json", allocation_category: allocation_category)
    end
  end

  def delete(conn, %{"id" => id}) do
    allocation_category = Organisations.get_allocation_category!(id)

    with {:ok, %AllocationCategory{}} <-
           Organisations.delete_allocation_category(allocation_category) do
      send_resp(conn, :no_content, "")
    end
  end
end
