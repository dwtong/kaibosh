defmodule KaiboshWeb.RecipientView do
  use KaiboshWeb, :view
  alias KaiboshWeb.RecipientView

  def render("index.json", %{recipients: recipients}) do
    render_many(recipients, RecipientView, "recipient.json")
  end

  def render("show.json", %{recipient: recipient}) do
    render_one(recipient, RecipientView, "recipient.json")
  end

  def render("recipient.json", %{recipient: recipient}) do
    %{
      id: recipient.id,
      name: recipient.name,
      status: "pending",
      base_id: recipient.base_id
    }
  end
end
