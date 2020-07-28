defmodule Kaibosh.Organisations.Category do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset

  @allowed_attrs [:name, :unit, :image_name]
  @required_attrs [:name, :unit, :image_name]

  schema "categories" do
    field :name, :string
    field :unit, :string
    field :image_name, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
