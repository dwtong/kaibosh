defmodule Kaibosh.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Base

  @allowed_attrs [:day, :time_in_seconds, :base_id]
  @required_attrs [:day, :time_in_seconds, :base_id]

  schema "sessions" do
    belongs_to :base, Base

    field :day, :string
    field :time_in_seconds, :integer

    timestamps()
  end

  @doc false
  def changeset(%__MODULE_{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
