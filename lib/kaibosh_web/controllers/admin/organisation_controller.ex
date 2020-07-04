defmodule KaiboshWeb.Admin.OrganisationController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Organisations.Organisation

  action_fallback KaiboshWeb.FallbackController

  def show(conn, %{"id" => id}) do
    organisation = Organisations.get_organisation!(id)
    render(conn, "show.json", organisation: organisation)
  end

  def index(conn, _params) do
    organisations = Organisations.list_organisations()
    render(conn, "index.json", organisations: organisations)
  end

  def create(conn, %{"organisation" => organisation_params}) do
    with {:ok, %Organisation{} = organisation} <-
           Organisations.create_organisation(organisation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.organisation_path(conn, :show, organisation))
      |> render("show.json", organisation: organisation)
    end
  end

  def update(conn, %{"id" => id, "organisation" => organisation_params}) do
    organisation = Organisations.get_organisation!(id)

    with {:ok, %Organisation{} = organisation} <-
           Organisations.update_organisation(organisation, organisation_params) do
      render(conn, "show.json", organisation: organisation)
    end
  end

  def delete(conn, %{"id" => id}) do
    organisation = Organisations.get_organisation!(id)

    with {:ok, %Organisation{}} <- Organisations.delete_organisation(organisation) do
      send_resp(conn, :no_content, "")
    end
  end
end
