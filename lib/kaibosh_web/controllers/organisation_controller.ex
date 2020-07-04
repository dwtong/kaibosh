defmodule KaiboshWeb.OrganisationController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def show(conn, %{"id" => id}) do
    organisation = Organisations.get_organisation!(id)
    render(conn, "show.json", organisation: organisation)
  end
end
