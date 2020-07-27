defmodule KaiboshWeb.UserView do
  use KaiboshWeb, :view
  alias KaiboshWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{email: user.email}
  end
end
