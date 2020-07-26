defmodule KaiboshWeb.UserView do
  use KaiboshWeb, :view
  alias KaiboshWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("password_updated.json", _) do
    %{message: "Password updated."}
  end

  def render("password_sent.json", _) do
    %{message: "Password email sent."}
  end

  def render("not_found.json", _) do
    %{message: "User not found."}
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{email: user.email}
  end
end
