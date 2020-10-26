defmodule KaiboshWeb.SignupView do
  use KaiboshWeb, :view
  alias KaiboshWeb.SignupView

  def render("bases.json", %{bases: bases}) do
    render_many(bases, SignupView, "base.json", as: :base)
  end

  def render("base.json", %{base: base}) do
    %{id: base.id, name: base.name}
  end

  def render("show.json", %{recipient: recipient}) do
    render_one(recipient, SignupView, "recipient.json", as: :recipient)
  end

  def render("recipient.json", %{recipient: recipient}) do
    %{name: recipient.name}
  end
end
