defmodule Kaibosh.RecipientSessions.RecipientSession do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Recipients.Recipient
  alias Kaibosh.Sessions.Session

  @allowed_attrs [:session_id, :recipient_id]
  @required_attrs [:session_id, :recipient_id]

  schema "recipient_sessions" do
    belongs_to :recipient, Recipient
    belongs_to :session, Session

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
  end
end
