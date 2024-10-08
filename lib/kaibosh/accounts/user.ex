defmodule Kaibosh.Accounts.User do
  @moduledoc false
  use Kaibosh.Schema
  import Ecto.Changeset
  alias Kaibosh.Accounts.User
  alias Kaibosh.Accounts.UserSession

  @allowed_attrs [:email, :password, :password_reset_token]
  @required_attrs [:email]

  schema "users" do
    has_many :user_sessions, UserSession

    field :email, :string
    field :password_hash, :string
    field :password_reset_token, :string

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
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "invalid password"}
    end
  end
end
