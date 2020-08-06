defmodule Kaibosh.Sessions do
  @moduledoc """
  The Sessions context.
  """
  import Kaibosh.Sessions.Query
  alias Kaibosh.Repo
  alias Kaibosh.Sessions.Plan
  alias Kaibosh.Sessions.Session

  def list_session_times_for_base(base_id) do
    base_id
    |> get_sessions_by_base_id()
    |> Repo.all()
  end

  def list_plans_for_base_and_week(base_id, week_of_date) do
    base_id
    |> get_sessions_with_recipients()
    |> Repo.all()
    |> Enum.map(fn session ->
      session
      |> Session.put_date(week_of_date)
      |> Plan.new()
    end)
  end

  def get_session!(id), do: Repo.get!(Session, id)

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end
end
