defmodule Kaibosh.Repo.Migrations.CreateBases do
  use Ecto.Migration

  def change do
    create table(:bases) do
      add :name, :string, null: false
      add :organisation_id, references(:organisations, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:bases, [:organisation_id])

    create unique_index(:bases, [:name, :organisation_id],
             name: :bases_organisation_id_name_index
           )
  end
end
