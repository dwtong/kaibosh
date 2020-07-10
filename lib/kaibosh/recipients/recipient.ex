defmodule Kaibosh.Recipients.Recipient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Recipients.Contact

  @allowed_attrs [
    :name,
    :physical_address,
    :description,
    :started_at,
    :archived_at,
    :signed_terms_at,
    :met_kaibosh_at,
    :base_id
  ]

  @required_attrs [:name, :base_id]

  schema "recipients" do
    has_one :contact, Contact
    belongs_to :base, Base

    field :name, :string, null: false
    field :physical_address, :string
    field :description, :string
    field :started_at, :utc_datetime
    field :archived_at, :utc_datetime
    field :signed_terms_at, :utc_datetime
    field :met_kaibosh_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> cast_assoc(:contact)
  end
end
