# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kaibosh.Repo.insert!(%Kaibosh.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Admin to change password after seeding DB
alias Kaibosh.Accounts
alias Kaibosh.Accounts.User
alias Kaibosh.Repo
alias Kaibosh.Organisations.Base
alias Kaibosh.Organisations.Category
alias Kaibosh.Organisations.Organisation
alias Kaibosh.Sessions.Session

unless Repo.exists?(User) do
  Accounts.create_user(%{email: "dev@kaibosh.org.nz", password: "password"})
end

now = DateTime.utc_now()

insert = fn schema, records ->
  records
  |> Enum.map(&Map.merge(&1, %{inserted_at: now, updated_at: now}))
  |> (&Repo.insert_all(schema, &1)).()
end

insert.(Organisation, [%{name: "Food Rescue Co."}])

org = Repo.one(Organisation)

insert.(Base, [
  %{name: "Food Rescue Wellington", organisation_id: org.id},
  %{name: "Food Rescue Auckland", organisation_id: org.id},
  %{name: "Food Rescue Christchurch", organisation_id: org.id}
])

bases = Repo.all(Base)

insert.(Category, [
  %{name: "bread", unit: "box", image_name: "bread"},
  %{name: "bakery", unit: "box", image_name: "bakery"},
  %{name: "produce (fruit only)", unit: "box", image_name: "produce_fruit_only"},
  %{name: "produce (all)", unit: "box", image_name: "produce_all"},
  %{name: "beverages", unit: "box", image_name: "beverages"},
  %{name: "dairy", unit: "box", image_name: "dairy_all"},
  %{name: "meat", unit: "box", image_name: "meat"},
  %{name: "other", unit: "box", image_name: "other"}
])

Enum.each(bases, fn %{id: base_id} ->
  ["monday", "tuesday", "wednesday", "thursday", "friday"]
  |> Enum.map(
    &[
      %{day: &1, time: ~T[10:00:00], base_id: base_id},
      %{day: &1, time: ~T[16:00:00], base_id: base_id}
    ]
  )
  |> List.flatten()
  |> (&insert.(Session, &1)).()
end)
