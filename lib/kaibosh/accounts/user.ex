defmodule Kaibosh.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaibosh.Accounts.UserSession
  alias Kaibosh.Accounts.User

  @allowed_attrs [:email, :password]
  @required_attrs [:email, :password]

  schema "users" do
    has_many :user_sessions, UserSession

    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = record, attrs) do
    record
    |> cast(attrs, @allowed_attrs)
    |> validate_required(@required_attrs)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end

  def check_password(%User{} = user, password) do
    Argon2.check_pass(user, password)
  end
end
