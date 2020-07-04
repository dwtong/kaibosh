defmodule Kaibosh.Repo.Migrations.CreateRecipients do
  use Ecto.Migration

  def change do
    create table(:recipients) do
      add :base_id, references(:bases, on_delete: :nothing), null: false

      add :name, :string, null: false
      add :physical_address, :text
      add :description, :text
      add :started_at, :utc_datetime
      add :archived_at, :utc_datetime
      add :signed_terms_at, :utc_datetime
      add :met_kaibosh_at, :utc_datetime

      timestamps()
    end

    create index(:recipients, [:base_id])
    create unique_index(:recipients, [:base_id, :name])
  end
end
