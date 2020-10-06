defmodule Kaibosh.Repo.Migrations.AddSignedUpAtToRecipients do
  use Ecto.Migration

  def change do
    alter table(:recipients) do
      add :signed_up_at, :utc_datetime_usec
    end
  end
end
