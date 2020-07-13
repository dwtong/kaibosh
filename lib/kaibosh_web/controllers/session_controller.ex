defmodule KaiboshWeb.SessionController do
  use KaiboshWeb, :controller

  alias Kaibosh.Sessions

  action_fallback KaiboshWeb.FallbackController

  def index(conn, %{"base_id" => base_id}) do
    sessions = Sessions.list_sessions_for_base(base_id)
    render(conn, "index.json", sessions: sessions)
  end
end
