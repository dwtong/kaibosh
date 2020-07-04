defmodule Kaibosh.Repo.Migrations.CreateStaff do
  use Ecto.Migration

  def change do
    create table(:staff) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :base_id, references(:bases, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:staff, [:base_id])
  end
end
