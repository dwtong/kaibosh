defmodule Kaibosh.Repo.Migrations.RemoveUnusedFoodCategories do
  use Ecto.Migration
  import Ecto.Query
  alias Kaibosh.Repo

  def change do
    other_category_id =
      "categories"
      |> where([c], c.name == "other")
      |> select([c], c.id)
      |> Repo.one()

    if other_category_id do
      sessions_with_other =
        "allocations"
        |> where([a], a.category_id == ^other_category_id)
        |> select([a], a.recipient_session_id)

      "allocations"
      |> join(:inner, [a], c in "categories", on: c.id == a.category_id)
      |> where([a, c], c.name == "ready meals / sandwiches")
      |> where([a], a.recipient_session_id in subquery(sessions_with_other))
      |> Repo.delete_all()

      "allocations"
      |> join(:inner, [a], c in "categories", on: c.id == a.category_id)
      |> where([a, c], c.name == "ready meals / sandwiches")
      |> Repo.update_all(set: [category_id: other_category_id])
    end

    dairy_category_id =
      "categories"
      |> where([c], c.name == "dairy (all)")
      |> select([c], c.id)
      |> Repo.one()

    if dairy_category_id do
      sessions_with_dairy =
        "allocations"
        |> where([a], a.category_id == ^dairy_category_id)
        |> select([a], a.recipient_session_id)

      "allocations"
      |> join(:inner, [a], c in "categories", on: c.id == a.category_id)
      |> where([a, c], c.name == "dairy (milk only)")
      |> where([a], a.recipient_session_id in subquery(sessions_with_dairy))
      |> Repo.delete_all()

      "allocations"
      |> join(:inner, [a], c in "categories", on: c.id == a.category_id)
      |> where([a, c], c.name == "dairy (milk only)")
      |> Repo.update_all(set: [category_id: dairy_category_id])

      "categories"
      |> where([c], c.name in ^["dairy (milk only)", "ready meals / sandwiches"])
      |> Repo.delete_all()

      "categories"
      |> where([c], c.name == "dairy (all)")
      |> Repo.update_all(set: [name: "dairy"])
    end
  end
end
