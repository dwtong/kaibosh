defmodule KaiboshWeb.RecipientView do
  use KaiboshWeb, :view
  alias KaiboshWeb.RecipientView

  def render("index.json", %{recipients: recipients}) do
    render_many(recipients, RecipientView, "recipient.json")
  end

  def render("show.json", %{recipient: recipient}) do
    render_one(recipient, RecipientView, "recipient_details.json")
  end

  def render("recipient.json", %{recipient: recipient}) do
    %{
      id: recipient.id,
      name: recipient.name,
      status: recipient.status,
      base_id: recipient.base_id
    }
  end

  def render("recipient_details.json", %{recipient: recipient}) do
    %{
      id: recipient.id,
      status: recipient.status,
      description: recipient.description,
      has_met_kaibosh: !is_nil(recipient.met_kaibosh_at),
      has_signed_terms: !is_nil(recipient.signed_terms_at),
      name: recipient.name,
      physical_address: recipient.physical_address,
      started_at: recipient.started_at,
      base_id: recipient.base_id,
      contact: render_one(recipient.contact, RecipientView, "contact.json", as: :contact)
    }
  end

  def render("contact.json", %{contact: contact}) do
    %{
      email: contact.email,
      name: contact.name,
      phone_landline: contact.phone_landline,
      phone_mobile: contact.phone_mobile
    }
  end
end
