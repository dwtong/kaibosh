defmodule KaiboshWeb.Admin.RecipientSessionController do
  use KaiboshWeb, :controller

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.RecipientSession

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    recipient_sessions = RecipientSessions.list_recipient_sessions()
    render(conn, "index.json", recipient_sessions: recipient_sessions)
  end

  def create(conn, %{"recipient_session" => recipient_session_params}) do
    with {:ok, %RecipientSession{} = recipient_session} <-
           RecipientSessions.create_recipient_session(recipient_session_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.recipient_session_path(
          conn,
          :show,
          recipient_session
        )
      )
      |> render("show.json", recipient_session: recipient_session)
    end
  end

  def show(conn, %{"id" => id}) do
    recipient_session = RecipientSessions.get_recipient_session!(id)
    render(conn, "show.json", recipient_session: recipient_session)
  end

  def update(conn, %{"id" => id, "recipient_session" => recipient_session_params}) do
    recipient_session = RecipientSessions.get_recipient_session!(id)

    with {:ok, %RecipientSession{} = recipient_session} <-
           RecipientSessions.update_recipient_session(recipient_session, recipient_session_params) do
      render(conn, "show.json", recipient_session: recipient_session)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipient_session = RecipientSessions.get_recipient_session!(id)

    with {:ok, %RecipientSession{}} <-
           RecipientSessions.delete_recipient_session(recipient_session) do
      send_resp(conn, :no_content, "")
    end
  end
end
