defmodule Kaibosh.Repo.Migrations.CreateRecipientSessions do
  use Ecto.Migration

  def change do
    create table(:recipient_sessions) do
      add :session_id, references(:sessions, on_delete: :nothing), null: false
      add :recipient_id, references(:recipients, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:recipient_sessions, [:session_id])
    create index(:recipient_sessions, [:recipient_id])
    create index(:recipient_sessions, [:recipient_id, :session_id])
  end
end
