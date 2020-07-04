defmodule KaiboshWeb.StaffView do
  use KaiboshWeb, :view
  alias KaiboshWeb.StaffView

  def render("index.json", %{staff: staff}) do
    %{data: render_many(staff, StaffView, "staff.json")}
  end

  def render("show.json", %{staff: staff}) do
    %{data: render_one(staff, StaffView, "staff.json")}
  end

  def render("staff.json", %{staff: staff}) do
    %{id: staff.id, first_name: staff.first_name, last_name: staff.last_name}
  end
end
