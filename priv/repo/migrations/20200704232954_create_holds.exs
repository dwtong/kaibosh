defmodule Kaibosh.Repo.Migrations.CreateHolds do
  use Ecto.Migration

  def change do
    create table(:holds) do
      add :starts_at, :utc_datetime_usec, null: false
      add :ends_at, :utc_datetime_usec

      add :recipient_session_id, references(:recipient_sessions, on_delete: :delete_all),
        null: false

      timestamps()
    end

    create index(:holds, [:recipient_session_id])
  end
end
