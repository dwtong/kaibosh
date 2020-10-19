defmodule Kaibosh.Repo.Migrations.CreateUserBaseNotifications do
  use Ecto.Migration

  def change do
    create table(:user_base_notifications) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :base_id, references(:bases, on_delete: :delete_all)
    end
  end
end
