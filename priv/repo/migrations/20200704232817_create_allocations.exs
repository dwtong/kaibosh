defmodule Kaibosh.Repo.Migrations.CreateAllocations do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :quantity, :decimal

      add :allocation_category_id, references(:allocation_categories, on_delete: :nothing),
        null: false

      add :recipient_session_id, references(:recipient_sessions, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:allocations, [:allocation_category_id])
    create index(:allocations, [:recipient_session_id])
  end
end
