defmodule KaiboshWeb.Admin.CategoryController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Category

  action_fallback KaiboshWeb.FallbackController

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <-
           Organisations.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.category_path(conn, :show, category)
      )
      |> render("show.json", category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Organisations.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Organisations.get_category!(id)

    with {:ok, %Category{} = category} <-
           Organisations.update_category(
             category,
             category_params
           ) do
      render(conn, "show.json", category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Organisations.get_category!(id)

    with {:ok, %Category{}} <-
           Organisations.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end
end
