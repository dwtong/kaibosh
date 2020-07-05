defmodule Kaibosh.Repo.Migrations.CreateAllocationCategories do
  use Ecto.Migration

  def change do
    create table(:allocation_categories) do
      add :organisation_id, references(:organisations, on_delete: :nothing), null: false
      add :name, :string, null: false
      add :unit, :string, null: false

      timestamps()
    end

    create index(:allocation_categories, [:organisation_id])
  end
end
