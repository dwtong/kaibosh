defmodule Kaibosh.PlansTest do
  @moduledoc false
  use Kaibosh.DataCase
  alias Kaibosh.Plans

  describe "weekly plans" do
    setup [:create_session_with_recipient]

    test "lists with multiple recipients", %{base: base, session: session} do
      insert(:recipient_session,
        recipient: build(:recipient, base: base),
        session: session,
        holds: [insert(:hold)]
      )

      [%{recipients: recipients}] = Plans.list_plans_for_week(base.id, ~D[2020-01-01])

      assert length(recipients) == 2
      assert [r1, r2] = recipients
      assert r1.status == :active
      assert r2.status == :on_hold
    end

    test "includes recipient details", %{base: base, recipient: recipient, session: session} do
      assert [%{session: s, recipients: [r1]}] =
               Plans.list_plans_for_week(base.id, ~D[2020-01-01])

      assert s.id == session.id
      assert r1.id == recipient.id
      assert r1.name == recipient.name
      assert r1.status == :active
    end
  end

  defp create_session_with_recipient(_) do
    base = insert(:base)
    session = insert(:session, base: base)
    recipient = insert(:recipient, base: base)
    insert(:recipient_session, recipient: recipient, session: session)
    %{base: base, recipient: recipient, session: session}
  end
end
