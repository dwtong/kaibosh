defmodule Kaibosh.RecipientSessions.Allocation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.AllocationCategory
  alias Kaibosh.RecipientSessions.RecipientSession

  @allowed_attrs [:quantity, :allocation_category_id, :recipient_session_id]
  @required_attrs [:allocation_category_id, :recipient_session_id]

  schema "allocations" do
    belongs_to :allocation_category, AllocationCategory
    belongs_to :recipient_session, RecipientSession

    field :quantity, :decimal

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
