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
      recipient_session: recipient_session,
      allocation: allocation
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

      assert %{"session" => session, "recipients" => [recipient], "allocations" => [a1, _a2]} =
               json_response(conn, 200)

      assert session["id"] == recipient_session.session_id
      refute is_nil(session["date"])

      assert recipient["id"] == recipient_session.recipient_id
      assert recipient["status"] == "active"
      assert recipient["description"] == recipient_session.recipient.description

      assert a1["quantity"] == Decimal.to_string(allocation.quantity)
      assert a1["category_id"] == allocation.category_id
      assert a1["recipient_id"] == allocation.recipient_session.recipient_id
    end
  end

  defp create_session(_) do
    base = insert(:base)
    session = insert(:session, base: base)
    recipient = insert(:recipient, base: base, description: "recipient desc")
    recipient_session = insert(:recipient_session, recipient: recipient, session: session)
    allocation = insert(:allocation, recipient_session: recipient_session, quantity: 5)

    %{recipient_session: recipient_session} =
      insert(:allocation, recipient_session: recipient_session)

    %{recipient_session: recipient_session, allocation: allocation}
  end
end
