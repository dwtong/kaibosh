defmodule KaiboshWeb.Admin.SessionView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.SessionView

  def render("index.json", %{sessions: sessions}) do
    %{data: render_many(sessions, SessionView, "session.json")}
  end

  def render("show.json", %{session: session}) do
    %{data: render_one(session, SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{id: session.id, day: session.day, time: session.time}
  end
end
