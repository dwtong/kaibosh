defmodule Kaibosh.Organisations.Base do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Organisation

  @allowed_attrs [:name, :organisation_id]
  @required_attrs [:name, :organisation_id]

  schema "bases" do
    belongs_to :organisation, Organisation

    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:name, name: :bases_organisation_id_name_index)
  end
end
