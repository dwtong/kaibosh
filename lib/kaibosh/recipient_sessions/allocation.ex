defmodule Kaibosh.RecipientSessions.Allocation do
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Category
  alias Kaibosh.RecipientSessions.Allocation
  alias Kaibosh.RecipientSessions.RecipientSession

  @allowed_attrs [:id, :quantity, :category_id]
  @required_attrs [:category_id]

  schema "allocations" do
    belongs_to :category, Category
    belongs_to :recipient_session, RecipientSession

    field :quantity, :decimal

    timestamps()
  end

  @doc false
  def changeset(%Allocation{} = allocation, attrs) do
    allocation
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
