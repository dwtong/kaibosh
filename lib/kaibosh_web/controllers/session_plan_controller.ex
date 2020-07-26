defmodule KaiboshWeb.SessionPlanController do
  use KaiboshWeb, :controller
  alias Kaibosh.Plans

  def index(conn, %{"base_id" => base_id, "week_of_date" => date}) do
    with {:ok, date} <- Date.from_iso8601(date) do
      plans = Plans.list_plans_for_week(base_id, date)
      render(conn, "index.json", plans: plans)
    end
  end

  def show(conn, %{"base_id" => base_id, "id" => session_id, "date" => date}) do
    with {:ok, date} <- Date.from_iso8601(date) do
      plan = Plans.get_plan_for_session(base_id, session_id, date)
      render(conn, "show.json", plan: plan)
    end
  end
end
