defmodule KaiboshWeb.BaseController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, %{"organisation_id" => org_id}) do
    bases = Organisations.list_bases_for_org(org_id)
    render(conn, "index.json", bases: bases)
  end
end
