defmodule KaiboshWeb.UserSessionView do
  use KaiboshWeb, :view

  def render("created.json", _) do
    %{message: "Session created."}
  end

  def render("not_found.json", _) do
    %{message: "User not found."}
  end
end
