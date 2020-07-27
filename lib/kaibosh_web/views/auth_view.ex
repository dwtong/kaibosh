defmodule KaiboshWeb.AuthView do
  use KaiboshWeb, :view

  def render("created.json", _) do
    %{message: "Session created."}
  end

  def render("password_updated.json", _) do
    %{message: "Password updated."}
  end

  def render("password_sent.json", _) do
    %{message: "Password email sent."}
  end
end
