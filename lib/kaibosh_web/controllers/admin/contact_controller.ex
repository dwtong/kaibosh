defmodule KaiboshWeb.Admin.ContactController do
  use KaiboshWeb, :controller

  alias Kaibosh.Recipients
  alias Kaibosh.Recipients.Contact

  action_fallback KaiboshWeb.FallbackController

  def create(conn, %{"contact" => contact_params}) do
    with {:ok, %Contact{} = contact} <- Recipients.create_contact(contact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.recipient_contact_path(conn, :show, contact.recipient_id, contact)
      )
      |> render("show.json", contact: contact)
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Recipients.get_contact!(id)
    render(conn, "show.json", contact: contact)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Recipients.get_contact!(id)

    with {:ok, %Contact{} = contact} <- Recipients.update_contact(contact, contact_params) do
      render(conn, "show.json", contact: contact)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Recipients.get_contact!(id)

    with {:ok, %Contact{}} <- Recipients.delete_contact(contact) do
      send_resp(conn, :no_content, "")
    end
  end
end
