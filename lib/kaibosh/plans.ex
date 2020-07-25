defmodule Kaibosh.Plans do
  @moduledoc """
  The Plans context.
  """

  import Kaibosh.Plans.Query
  alias Kaibosh.Plans.Session
  alias Kaibosh.Repo

  def list_plans_for_week(base_id, week_starts_at) do
    base_id
    |> get_recipients_and_sessions_by_base(week_starts_at)
    |> Repo.all()
    |> Session.build_sessions(week_starts_at)
  end

  def get_plan_for_session(base_id, session_id, date) do
    allocations =
      session_id
      |> get_allocations_for_session()
      |> Repo.all()

    base_id
    |> get_recipients_for_session(session_id, date)
    |> Repo.all()
    |> Session.build_sessions(date)
    |> List.first()
    |> Map.put(:allocations, allocations)
  end
end
