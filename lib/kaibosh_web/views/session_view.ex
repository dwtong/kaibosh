defmodule KaiboshWeb.SessionView do
  use KaiboshWeb, :view
  alias KaiboshWeb.SessionView

  def render("index.json", %{sessions: sessions}) do
    render_many(sessions, SessionView, "session.json")
  end

  def render("session.json", %{session: session}) do
    %{id: session.id, day: session.day, time: session.time}
  end
end
