defmodule KaiboshWeb.RecipientSessionView do
  use KaiboshWeb, :view
  alias KaiboshWeb.RecipientSessionView

  def render("index.json", %{recipient_sessions: recipient_sessions}) do
    render_many(recipient_sessions, RecipientSessionView, "recipient_session.json")
  end

  def render("show.json", %{recipient_session: recipient_session}) do
    render_one(recipient_session, RecipientSessionView, "recipient_session.json")
  end

  def render("recipient_session.json", %{recipient_session: session}) do
    %{
      id: session.id,
      day: session.session.day,
      time: session.session.time,
      session_id: session.session_id,
      allocations:
        render_many(session.allocations, RecipientSessionView, "allocation.json", as: :allocation),
      holds: render_many(session.holds, RecipientSessionView, "hold.json", as: :hold)
    }
  end

  def render("allocation.json", %{allocation: allocation}) do
    %{
      id: allocation.id,
      category_id: allocation.category_id,
      quantity: allocation.quantity
    }
  end

  def render("hold.json", %{hold: hold}) do
    %{
      id: hold.id,
      starts_at: hold.starts_at,
      ends_at: hold.ends_at
    }
  end
end
