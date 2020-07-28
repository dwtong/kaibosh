defmodule Kaibosh.Organisations.Query do
  @moduledoc """
  Queries used by Organisations context.

  Queries should be pure functions, any calls to Repo.*
  (impure functions) belong in context module.
  """
  import Ecto.Query
  alias Kaibosh.Organisations.Base
  alias Kaibosh.Organisations.Staff

  def get_base_by_org_id(org_id) do
    Base
    |> where(organisation_id: ^org_id)
  end

  def get_staff_by_org_id(org_id) do
    Staff
    |> join(:inner, [s], b in assoc(s, :base))
    |> where([s, b], b.organisation_id == ^org_id)
  end
end
