defmodule KaiboshWeb.HoldControllerTest do
  use KaiboshWeb.ConnCase

  alias Kaibosh.RecipientSessions.Hold

  @create_attrs %{
    ends_at: ~U[2010-04-17 14:00:00.000000Z],
    starts_at: ~U[2010-04-17 14:00:00.000000Z]
  }

  @invalid_attrs %{ends_at: nil, starts_at: nil}

  describe "create hold" do
    test "renders hold when data is valid", %{conn: conn} do
      recipient_session = insert(:recipient_session)
      attrs = Map.put(@create_attrs, :recipient_session_id, recipient_session.id)

      conn =
        post(conn, Routes.recipient_hold_path(conn, :create, recipient_session.recipient_id),
          hold: attrs
        )

      assert json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      recipient_session = insert(:recipient_session)

      conn =
        post(conn, Routes.recipient_hold_path(conn, :create, recipient_session.recipient_id),
          hold: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete hold" do
    setup [:create_hold]

    test "deletes chosen hold", %{conn: conn, hold: hold} do
      conn =
        delete(
          conn,
          Routes.recipient_hold_path(conn, :delete, hold.recipient_session.recipient_id, hold)
        )

      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Repo.get!(Hold, hold.id) end
    end
  end

  defp create_hold(_) do
    hold = insert(:hold)
    %{hold: hold}
  end
end
