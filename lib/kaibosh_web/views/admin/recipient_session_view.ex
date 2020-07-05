defmodule KaiboshWeb.Admin.RecipientSessionView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.RecipientSessionView

  def render("index.json", %{recipient_sessions: recipient_sessions}) do
    %{data: render_many(recipient_sessions, RecipientSessionView, "recipient_session.json")}
  end

  def render("show.json", %{recipient_session: recipient_session}) do
    %{data: render_one(recipient_session, RecipientSessionView, "recipient_session.json")}
  end

  def render("recipient_session.json", %{recipient_session: recipient_session}) do
    %{id: recipient_session.id}
  end
end
