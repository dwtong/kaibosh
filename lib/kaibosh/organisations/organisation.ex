defmodule Kaibosh.Organisations.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_attrs [:name]
  @required_attrs [:name]

  schema "organisations" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
