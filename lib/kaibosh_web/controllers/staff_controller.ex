defmodule KaiboshWeb.StaffController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, %{"organisation_id" => org_id}) do
    staff = Organisations.list_staff_for_org(org_id)
    render(conn, "index.json", staff: staff)
  end
end
