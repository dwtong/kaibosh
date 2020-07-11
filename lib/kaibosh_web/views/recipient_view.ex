defmodule KaiboshWeb.RecipientView do
  use KaiboshWeb, :view
  alias KaiboshWeb.RecipientView

  def render("index.json", %{recipients: recipients}) do
    %{data: render_many(recipients, RecipientView, "recipient.json")}
  end

  def render("show.json", %{recipient: recipient}) do
    %{data: render_one(recipient, RecipientView, "recipient.json")}
  end

  def render("recipient.json", %{recipient: recipient}) do
    %{id: recipient.id, name: recipient.name}
  end
end
