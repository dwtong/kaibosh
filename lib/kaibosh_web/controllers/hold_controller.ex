defmodule KaiboshWeb.HoldController do
  use KaiboshWeb, :controller

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.Hold

  action_fallback KaiboshWeb.FallbackController

  def create(conn, %{"hold" => hold_params}) do
    with {:ok, %Hold{} = hold} <- RecipientSessions.create_hold(hold_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.recipient_recipient_session_path(conn, :index, hold.recipient_session_id)
      )
      |> render("show.json", hold: hold)
    end
  end

  def delete(conn, %{"id" => id}) do
    hold = RecipientSessions.get_hold!(id)

    with {:ok, %Hold{}} <- RecipientSessions.delete_hold(hold) do
      send_resp(conn, :no_content, "")
    end
  end
end
