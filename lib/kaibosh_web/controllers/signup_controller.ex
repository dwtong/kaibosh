defmodule KaiboshWeb.SignupController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def bases(conn, _params) do
    bases = Organisations.list_bases()
    render(conn, "bases.json", bases: bases)
  end
end
