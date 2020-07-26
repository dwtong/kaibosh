defmodule Kaibosh.Repo.Migrations.AddPasswordTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_reset_token, :text
    end
  end
end
