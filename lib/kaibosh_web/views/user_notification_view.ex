defmodule KaiboshWeb.UserNotificationView do
  use KaiboshWeb, :view
  alias KaiboshWeb.UserNotificationView

  def render("index.json", %{user_notifications: notifications}) do
    render_many(notifications, UserNotificationView, "notification.json")
  end

  def render("show.json", %{user_notification: notification}) do
    render_one(notification, UserNotificationView, "notification.json")
  end

  def render("notification.json", %{user_notification: notification}) do
    %{
      id: notification.id,
      name: notification.name,
      enabled: notification.enabled
    }
  end
end
