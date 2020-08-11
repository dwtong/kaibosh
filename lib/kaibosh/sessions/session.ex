defmodule Kaibosh.Sessions.Session do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.Date
  alias Kaibosh.Sessions.Session

  @allowed_attrs [:day, :time, :base_id]
  @required_attrs [:day, :time, :base_id]

  schema "sessions" do
    belongs_to :base, Kaibosh.Organisations.Base
    has_many :recipient_sessions, Kaibosh.RecipientSessions.RecipientSession

    field :day, :string
    field :time, :time

    field :date, :date, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end

  def put_date(%Session{time: time, day: day} = session, week_starts_at) do
    session_date =
      week_starts_at
      |> Date.utc_datetime_from_local_date_and_time(time)
      |> Date.date_for_day_of_week(day)

    Map.put(session, :date, session_date)
  end
end
