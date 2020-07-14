defmodule Kaibosh.Organisations.Category do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Base

  @allowed_attrs [:name, :unit, :image_name, :base_id]
  @required_attrs [:name, :unit, :image_name, :base_id]

  schema "categories" do
    belongs_to :base, Base
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
