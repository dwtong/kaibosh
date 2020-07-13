defmodule Kaibosh.Accounts.UserSession do
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Ecto.UUID
  alias Kaibosh.Accounts.UserSession
  alias Kaibosh.Accounts.User

  @allowed_attrs [:user_id]
  @required_attrs [:user_id]

  schema "user_sessions" do
    belongs_to :user, User

    field :token, :binary_id

    timestamps()
  end

  @doc false
  def changeset(%UserSession{} = user_session, attrs) do
    user_session
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> put_token()
    |> unique_constraint(:token)
  end

  def put_token(%{data: %{token: nil}} = changeset) do
    put_change(changeset, :token, UUID.generate())
  end

  def put_token(changeset) do
    changeset
  end
end
