defmodule Kaibosh.Sessions.Session do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Sessions.Session

  @allowed_attrs [:day, :time_in_seconds, :base_id]
  @required_attrs [:day, :time_in_seconds, :base_id]

  schema "sessions" do
    belongs_to :base, Base

    field :day, :string
    field :time_in_seconds, :integer

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
