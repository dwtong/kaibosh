defmodule KaiboshWeb.Admin.StaffController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Staff

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    staff = Organisations.list_staff()
    render(conn, "index.json", staff: staff)
  end

  def create(conn, %{"staff" => staff_params}) do
    with {:ok, %Staff{} = staff} <- Organisations.create_staff(staff_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.staff_path(conn, :show, staff))
      |> render("show.json", staff: staff)
    end
  end

  def show(conn, %{"id" => id}) do
    staff = Organisations.get_staff!(id)
    render(conn, "show.json", staff: staff)
  end

  def update(conn, %{"id" => id, "staff" => staff_params}) do
    staff = Organisations.get_staff!(id)

    with {:ok, %Staff{} = staff} <- Organisations.update_staff(staff, staff_params) do
      render(conn, "show.json", staff: staff)
    end
  end

  def delete(conn, %{"id" => id}) do
    staff = Organisations.get_staff!(id)

    with {:ok, %Staff{}} <- Organisations.delete_staff(staff) do
      send_resp(conn, :no_content, "")
    end
  end
end
