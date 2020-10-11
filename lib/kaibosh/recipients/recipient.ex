defmodule Kaibosh.Recipients.Recipient do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
  import Kaibosh.Date, only: [now: 0]
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

  @signup_attrs [
    :name,
    :physical_address,
    :description,
    :base_id
  ]

  @required_attrs [:name, :base_id]

  schema "recipients" do
    has_one :contact, Contact, on_replace: :update
    belongs_to :base, Kaibosh.Organisations.Base

    field :name, :string, null: false
    field :physical_address, :string
    field :description, :string
    field :started_at, :utc_datetime_usec
    field :archived_at, :utc_datetime_usec
    field :signed_terms_at, :utc_datetime_usec
    field :met_kaibosh_at, :utc_datetime_usec
    field :signed_up_at, :utc_datetime_usec

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

  @doc false
  def signup_changeset(attrs) do
    # FIXME won't autoincrement because of this (rails migration issues?)https://stackoverflow.com/questions/9108833/postgres-autoincrement-not-updated-on-explicit-id-inserts/9108929#9108929
    %Recipient{}
    |> cast(attrs, @signup_attrs)
    |> validate_required(@required_attrs)
    |> cast_assoc(:contact)
    |> put_change(:signed_up_at, now())
    |> IO.inspect()
  end
end
