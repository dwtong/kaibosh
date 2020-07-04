defmodule Kaibosh.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :recipient_id, references(:recipients, on_delete: :delete_all), null: false

      add :name, :string, null: false
      add :email, :string
      add :phone_landline, :string
      add :phone_mobile, :string

      timestamps()
    end
  end
end
