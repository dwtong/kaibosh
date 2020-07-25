defmodule KaiboshWeb.SessionPlanControllerTest do
  use KaiboshWeb.ConnCase

  describe "list plans for week" do
    setup [:create_session]

    test "lists all plans for base for given week", %{
      conn: conn,
      recipient_session: recipient_session
    } do
      conn =
        get(
          conn,
          Routes.base_session_plan_path(
            conn,
            :index,
            recipient_session.recipient.base_id,
            week_of_date: "2020-07-01"
          )
        )

      assert [%{"session" => session, "recipients" => [recipient]}] = json_response(conn, 200)

      assert session["id"] == recipient_session.session_id
      refute is_nil(session["date"])

      assert recipient["id"] == recipient_session.recipient_id
      assert recipient["status"] == "active"
    end
  end

  describe "show plan for session" do
    setup [:create_session]

    test "shows plan for a given session on given date", %{
      conn: conn,
      recipient_session: recipient_session
    } do
      conn =
        get(
          conn,
          Routes.base_session_plan_path(
            conn,
            :show,
            recipient_session.recipient.base_id,
            recipient_session.session_id,
            date: "2020-07-01"
          )
        )

      assert %{"session" => session, "recipients" => [recipient], "allocations" => allocations} =
               json_response(conn, 200)

      assert session["id"] == recipient_session.session_id
      refute is_nil(session["date"])

      assert recipient["id"] == recipient_session.recipient_id
      assert recipient["status"] == "active"

      assert length(allocations) == 2
    end
  end

  defp create_session(_) do
    base = insert(:base)
    session = insert(:session, base: base)
    recipient = insert(:recipient, base: base)
    recipient_session = insert(:recipient_session, recipient: recipient, session: session)
    insert(:allocation, recipient_session: recipient_session, quantity: 5)

    %{recipient_session: recipient_session} =
      insert(:allocation, recipient_session: recipient_session)

    %{recipient_session: recipient_session}
  end
end
