defmodule Kaibosh.Repo.Migrations.CreateAllocationCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :base_id, references(:bases, on_delete: :nothing), null: false
      add :name, :string, null: false
      add :image_name, :string, null: false
      add :unit, :string, null: false

      timestamps()
    end

    create index(:categories, [:base_id])
  end
end
