defmodule KaiboshWeb.SignupController do
  use KaiboshWeb, :controller

  alias Kaibosh.Organisations
  alias Kaibosh.Recipients

  action_fallback KaiboshWeb.FallbackController

  def bases(conn, _params) do
    bases = Organisations.list_bases()
    render(conn, "bases.json", bases: bases)
  end

  def create(conn, %{"recipient" => recipient}) do
    IO.inspect(recipient)

    with {:ok, recipient} <- Recipients.create_recipient_signup(recipient) do
      conn
      |> put_status(:created)
      |> render("show.json", recipient: recipient)
    end
  end
end
