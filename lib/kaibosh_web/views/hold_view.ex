defmodule KaiboshWeb.HoldView do
  use KaiboshWeb, :view
  alias KaiboshWeb.HoldView

  def render("show.json", %{hold: hold}) do
    %{data: render_one(hold, HoldView, "hold.json")}
  end

  def render("hold.json", %{hold: hold}) do
    %{id: hold.id, starts_at: hold.starts_at, ends_at: hold.ends_at}
  end
end
