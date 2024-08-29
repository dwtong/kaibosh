defmodule Kaibosh.Repo.Migrations.MakeEmailsCaseInsensitive do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION citext")

    alter table(:users) do
      modify(:email, :citext)
    end
  end
end
