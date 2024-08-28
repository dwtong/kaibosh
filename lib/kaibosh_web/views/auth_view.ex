defmodule KaiboshWeb.AuthView do
  alias Kaibosh.Accounts.User
  use KaiboshWeb, :view

  def render("created.json", _) do
    %{message: "Session created."}
  end

  def render("password_updated.json", %{user: %User{email: email}}) do
    %{message: "Password updated.", email: email}
  end

  def render("password_sent.json", _) do
    %{message: "Password email sent."}
  end
end
