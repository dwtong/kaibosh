defmodule KaiboshWeb.UserNotificationController do
  use KaiboshWeb, :controller

  alias Kaibosh.Accounts
  alias Kaibosh.Accounts.User
  alias Kaibosh.Organisations

  action_fallback KaiboshWeb.FallbackController

  def index(conn, _params) do
    user_notifications =
      conn
      |> fetch_session()
      |> get_session(:user_id)
      |> Accounts.get_user!()
      |> Accounts.get_base_notifications_for_user()

    notifications =
      Organisations.list_bases()
      |> Enum.map(&Map.put(&1, :enabled, Enum.member?(user_notifications, &1.id)))

    render(conn, "index.json", user_notifications: notifications)
  end

  def create(conn, %{"base_id" => base_id}) do
    with conn <- fetch_session(conn),
         user_id <- get_session(conn, :user_id),
         %User{} = user <- Accounts.get_user!(user_id),
         :ok <- Accounts.subscribe_user_to_base_notifications(user, base_id) do
      conn
      |> put_status(:created)
      |> render("show.json", user_notification: %{name: nil, id: base_id, enabled: true})
    end
  end

  def delete(conn, %{"id" => base_id}) do
    with conn <- fetch_session(conn),
         user_id <- get_session(conn, :user_id),
         %User{} = user <- Accounts.get_user!(user_id),
         base_id when is_integer(base_id) <- String.to_integer(base_id) do
      Accounts.unsubscribe_user_from_base_notifications(user, base_id)
      send_resp(conn, :no_content, "")
    end
  end
end
