defmodule KaiboshWeb.SessionPlanView do
  use KaiboshWeb, :view
  alias KaiboshWeb.SessionPlanView

  def render("index.json", %{plans: plans}) do
    render_many(plans, SessionPlanView, "plan.json", as: :plan)
  end

  def render("show.json", %{plan: plan}) do
    %{
      session: render_one(plan.session, SessionPlanView, "session.json", as: :session),
      recipients: render_many(plan.recipients, SessionPlanView, "recipient.json", as: :recipient),
      allocations:
        render_many(plan.allocations, SessionPlanView, "allocation.json", as: :allocation)
    }
  end

  def render("plan.json", %{plan: plan}) do
    %{
      session: render_one(plan.session, SessionPlanView, "session.json", as: :session),
      recipients: render_many(plan.recipients, SessionPlanView, "recipient.json", as: :recipient)
    }
  end

  def render("session.json", %{session: session}) do
    %{
      day: session.day,
      time: Time.truncate(session.time, :second),
      date: session.date,
      base_id: session.base_id,
      id: session.id
    }
  end

  def render("recipient.json", %{recipient: recipient}) do
    %{
      id: recipient.id,
      name: recipient.name,
      status: recipient.status
    }
  end

  def render("allocation.json", %{allocation: allocation}) do
    %{
      quantity: allocation.quantity,
      category_id: allocation.category_id
    }
  end
end
