defmodule Kaibosh.Recipients.Recipient do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Recipients.Contact
  alias Kaibosh.Recipients.Recipient

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
    has_one :contact, Contact, on_replace: :update
    belongs_to :base, Base

    field :name, :string, null: false
    field :physical_address, :string
    field :description, :string
    field :started_at, :utc_datetime
    field :archived_at, :utc_datetime
    field :signed_terms_at, :utc_datetime
    field :met_kaibosh_at, :utc_datetime

    field :status, :string, virtual: true
    field :session_count, :integer, virtual: true
    field :hold_count, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%Recipient{} = recipient, attrs) do
    recipient
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> cast_assoc(:contact)
  end
end
