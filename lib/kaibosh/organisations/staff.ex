defmodule Kaibosh.Organisations.Staff do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Base

  schema "staff" do
    belongs_to :base, Base

    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, [:first_name, :last_name, :base_id])
    |> validate_required([:first_name, :last_name, :base_id])
  end
end
