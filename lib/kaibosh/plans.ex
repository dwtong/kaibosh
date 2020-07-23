defmodule Kaibosh.Plans do
  @moduledoc """
  The Plans context.
  """

  import Kaibosh.Plans.Query
  alias Kaibosh.Plans.WeekPlan
  alias Kaibosh.Repo

  def list_plans_for_week(base_id, week_starts_at) do
    base_id
    |> get_plans_by_base(week_starts_at)
    |> Repo.all()
    |> WeekPlan.build(week_starts_at)
  end

  # def get_plan_for_sesson_on_date(session_id, date) do
  #   session_id
  #   |> get_plan_for_session_by_date(date)
  #   |> Repo.one!()
  # end
end
