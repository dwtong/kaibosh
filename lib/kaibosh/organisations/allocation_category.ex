defmodule Kaibosh.Organisations.AllocationCategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Organisation

  @allowed_attrs [:name, :unit, :organisation_id]
  @required_attrs [:name, :unit, :organisation_id]

  schema "allocation_categories" do
    belongs_to :organisation, Organisation
    field :name, :string
    field :unit, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
