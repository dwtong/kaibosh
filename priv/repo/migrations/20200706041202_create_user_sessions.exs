defmodule Kaibosh.Repo.Migrations.CreateUserSessions do
  use Ecto.Migration

  def change do
    create table(:user_sessions) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :token, :binary_id, null: false

      timestamps()
    end

    create unique_index(:user_sessions, [:token])
    create index(:user_sessions, [:user_id])
  end
end
