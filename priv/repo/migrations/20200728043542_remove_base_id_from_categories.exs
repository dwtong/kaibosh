defmodule Kaibosh.Repo.Migrations.RemoveBaseIdFromCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      remove :base_id
    end
  end
end
