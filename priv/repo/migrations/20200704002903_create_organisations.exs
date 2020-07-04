defmodule Kaibosh.Repo.Migrations.CreateOrganisations do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:organisations, [:name])
  end
end
