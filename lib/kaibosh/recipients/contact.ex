defmodule Kaibosh.Recipients.Contact do
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.Recipients.Recipient

  @allowed_attrs [:name, :email, :phone_landline, :phone_mobile]
  @required_attrs []
  @email_regex ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "contacts" do
    belongs_to :recipient, Recipient

    field :name, :string
    field :email, :string
    field :phone_landline, :string
    field :phone_mobile, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> validate_format(:email, @email_regex)
  end
end
