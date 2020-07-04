defmodule KaiboshWeb.Admin.OrganisationView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.OrganisationView

  def render("index.json", %{organisations: organisations}) do
    %{data: render_many(organisations, OrganisationView, "organisation.json")}
  end

  def render("show.json", %{organisation: organisation}) do
    %{data: render_one(organisation, OrganisationView, "organisation.json")}
  end

  def render("organisation.json", %{organisation: organisation}) do
    %{id: organisation.id, name: organisation.name}
  end
end
