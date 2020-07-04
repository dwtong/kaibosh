defmodule KaiboshWeb.Admin.BaseController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Base

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    bases = Organisations.list_bases()
    render(conn, "index.json", bases: bases)
  end

  def create(conn, %{"base" => base_params}) do
    with {:ok, %Base{} = base} <- Organisations.create_base(base_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.base_path(conn, :show, base))
      |> render("show.json", base: base)
    end
  end

  def show(conn, %{"id" => id}) do
    base = Organisations.get_base!(id)
    render(conn, "show.json", base: base)
  end

  def update(conn, %{"id" => id, "base" => base_params}) do
    base = Organisations.get_base!(id)

    with {:ok, %Base{} = base} <- Organisations.update_base(base, base_params) do
      render(conn, "show.json", base: base)
    end
  end

  def delete(conn, %{"id" => id}) do
    base = Organisations.get_base!(id)

    with {:ok, %Base{}} <- Organisations.delete_base(base) do
      send_resp(conn, :no_content, "")
    end
  end
end
