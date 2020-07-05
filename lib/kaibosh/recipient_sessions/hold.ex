defmodule Kaibosh.RecipientSessions.Hold do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.RecipientSessions.RecipientSession

  @allowed_attrs [:starts_at, :ends_at, :recipient_session_id]
  @required_attrs [:starts_at, :recipient_session_id]

  schema "holds" do
    belongs_to :recipient_session, RecipientSession

    field :ends_at, :utc_datetime
    field :starts_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
