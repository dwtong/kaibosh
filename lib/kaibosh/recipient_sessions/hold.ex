defmodule Kaibosh.RecipientSessions.Hold do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.RecipientSessions.RecipientSession

  @allowed_attrs [:starts_at, :ends_at, :recipient_session_id]
  @required_attrs [:starts_at, :recipient_session_id]

  schema "holds" do
    belongs_to :recipient_session, RecipientSession

    field :ends_at, :utc_datetime_usec
    field :starts_at, :utc_datetime_usec

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
