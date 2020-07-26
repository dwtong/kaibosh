defmodule KaiboshWeb.RecipientSessionController do
  use KaiboshWeb, :controller

  alias Kaibosh.RecipientSessions
  alias Kaibosh.RecipientSessions.RecipientSession

  action_fallback KaiboshWeb.FallbackController

  def index(conn, %{"recipient_id" => recipient_id}) do
    recipient_sessions = RecipientSessions.list_sessions_for_recipient(recipient_id)
    render(conn, "index.json", recipient_sessions: recipient_sessions)
  end

  def create(conn, %{"session" => recipient_session_params}) do
    with {:ok, %RecipientSession{} = recipient_session} <-
           RecipientSessions.create_session(recipient_session_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.recipient_recipient_session_path(
          conn,
          :show,
          recipient_session.recipient_id,
          recipient_session.id
        )
      )
      |> render("show.json", recipient_session: recipient_session)
    end
  end

  def show(conn, %{"id" => id}) do
    recipient_session = RecipientSessions.get_session!(id)
    render(conn, "show.json", recipient_session: recipient_session)
  end

  def update(conn, %{"id" => id, "session" => recipient_session_params}) do
    recipient_session = RecipientSessions.get_session!(id)

    with {:ok, %RecipientSession{} = recipient_session} <-
           RecipientSessions.update_session(recipient_session, recipient_session_params) do
      render(conn, "show.json", recipient_session: recipient_session)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipient_session = RecipientSessions.get_session!(id)

    with {:ok, %RecipientSession{}} <-
           RecipientSessions.delete_session(recipient_session) do
      send_resp(conn, :no_content, "")
    end
  end
end
