defmodule Kaibosh.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :day, :string, null: false
      add :time, :time, null: false
      add :base_id, references(:bases, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:sessions, [:base_id])
  end
end
