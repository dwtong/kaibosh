defmodule KaiboshWeb.Admin.HoldController do
  use KaiboshWeb, :controller

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.Hold

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    holds = RecipientSessions.list_holds()
    render(conn, "index.json", holds: holds)
  end

  def create(conn, %{"hold" => hold_params}) do
    with {:ok, %Hold{} = hold} <- RecipientSessions.create_hold(hold_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.hold_path(conn, :show, hold))
      |> render("show.json", hold: hold)
    end
  end

  def show(conn, %{"id" => id}) do
    hold = RecipientSessions.get_hold!(id)
    render(conn, "show.json", hold: hold)
  end

  def update(conn, %{"id" => id, "hold" => hold_params}) do
    hold = RecipientSessions.get_hold!(id)

    with {:ok, %Hold{} = hold} <- RecipientSessions.update_hold(hold, hold_params) do
      render(conn, "show.json", hold: hold)
    end
  end

  def delete(conn, %{"id" => id}) do
    hold = RecipientSessions.get_hold!(id)

    with {:ok, %Hold{}} <- RecipientSessions.delete_hold(hold) do
      send_resp(conn, :no_content, "")
    end
  end
end
