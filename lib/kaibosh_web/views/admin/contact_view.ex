defmodule KaiboshWeb.Admin.ContactView do
  use KaiboshWeb, :view
  alias KaiboshWeb.Admin.ContactView

  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{id: contact.id}
  end
end
