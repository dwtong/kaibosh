defmodule KaiboshWeb.BaseView do
  use KaiboshWeb, :view
  alias KaiboshWeb.BaseView

  def render("index.json", %{bases: bases}) do
    %{data: render_many(bases, BaseView, "base.json")}
  end

  def render("show.json", %{base: base}) do
    %{data: render_one(base, BaseView, "base.json")}
  end

  def render("base.json", %{base: base}) do
    %{id: base.id, name: base.name}
  end
end
