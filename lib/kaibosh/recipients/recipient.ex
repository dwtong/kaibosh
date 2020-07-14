defmodule Kaibosh.Recipients.Recipient do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
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
    field :started_at, :utc_datetime_usec
    field :archived_at, :utc_datetime_usec
    field :signed_terms_at, :utc_datetime_usec
    field :met_kaibosh_at, :utc_datetime_usec

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
