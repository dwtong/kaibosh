defmodule KaiboshWeb.UserNotificationControllerTest do
  use KaiboshWeb.ConnCase
  use Bamboo.Test

  alias Kaibosh.Accounts

  describe "subscribe user to notifications" do
    setup [:create_user, :create_base]

    test "subscribes user to base notifications", %{conn: conn, user: user, base: base} do
      assert Accounts.get_base_notifications_for_user(user) == []

      conn =
        post(conn, Routes.user_user_notification_path(conn, :create, user.id), %{base_id: base.id})

      assert json_response(conn, 201)

      assert Accounts.get_base_notifications_for_user(user) == [base.id]
    end
  end

  describe "list subscriptions for user" do
    setup [:create_user, :create_base, :subscribe_user_to_notifications]

    test "lists user's subscriptions", %{conn: conn, user: user, base: %{id: base_id}} do
      conn = get(conn, Routes.user_user_notification_path(conn, :index, user.id))
      assert [^base_id] = json_response(conn, 200)
    end
  end

  describe "delete subscription for user" do
    setup [:create_user, :create_base, :subscribe_user_to_notifications]

    test "deletes subscription for user", %{conn: conn, user: user, base: base} do
      assert Accounts.get_base_notifications_for_user(user) == [base.id]

      conn = delete(conn, Routes.user_user_notification_path(conn, :delete, user.id, base.id))
      assert response(conn, 204)

      assert Accounts.get_base_notifications_for_user(user) == []
    end
  end

  defp create_user(%{conn: conn}) do
    user_id = conn.private.plug_session["user_id"]
    %{user: insert(:user, id: user_id)}
  end

  defp create_base(_) do
    %{base: insert(:base)}
  end

  defp subscribe_user_to_notifications(%{user: user, base: base}) do
    Accounts.subscribe_user_to_base_notifications(user, base.id)
  end
end
