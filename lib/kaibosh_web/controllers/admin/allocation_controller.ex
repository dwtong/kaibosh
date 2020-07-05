defmodule KaiboshWeb.Admin.AllocationController do
  use KaiboshWeb, :controller

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.Allocation

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    allocations = RecipientSessions.list_allocations()
    render(conn, "index.json", allocations: allocations)
  end

  def create(conn, %{"allocation" => allocation_params}) do
    with {:ok, %Allocation{} = allocation} <-
           RecipientSessions.create_allocation(allocation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.allocation_path(conn, :show, allocation))
      |> render("show.json", allocation: allocation)
    end
  end

  def show(conn, %{"id" => id}) do
    allocation = RecipientSessions.get_allocation!(id)
    render(conn, "show.json", allocation: allocation)
  end

  def update(conn, %{"id" => id, "allocation" => allocation_params}) do
    allocation = RecipientSessions.get_allocation!(id)

    with {:ok, %Allocation{} = allocation} <-
           RecipientSessions.update_allocation(allocation, allocation_params) do
      render(conn, "show.json", allocation: allocation)
    end
  end

  def delete(conn, %{"id" => id}) do
    allocation = RecipientSessions.get_allocation!(id)

    with {:ok, %Allocation{}} <- RecipientSessions.delete_allocation(allocation) do
      send_resp(conn, :no_content, "")
    end
  end
end
