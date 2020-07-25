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

  describe "session plans" do
    setup [:create_session_with_recipient]

    test "lists categories with recipients allocations", %{recipient_session: recipient_session} do
      apples = insert(:category, name: "apples")
      bananas = insert(:category, name: "bananas")

      insert(:allocation, recipient_session: recipient_session, category: apples, quantity: 5)
      insert(:allocation, recipient_session: recipient_session, category: bananas, quantity: 2)

      base_id = recipient_session.recipient.base_id
      session_id = recipient_session.session_id

      assert %{session: session, allocations: [a1, a2], recipients: [r1]} =
               Plans.get_plan_for_session(base_id, session_id, ~D[2020-01-01])

      assert r1.id == recipient_session.recipient.id
      assert r1.name == recipient_session.recipient.name
      assert r1.status == :active

      assert a1.category_id == apples.id
      assert a2.category_id == bananas.id
      assert a1.quantity == Decimal.cast(5)
      assert a2.quantity == Decimal.cast(2)
      assert a1.recipient_id == r1.id
      assert a2.recipient_id == r1.id
    end
  end

  defp create_session_with_recipient(_) do
    base = insert(:base)
    session = insert(:session, base: base)
    recipient = insert(:recipient, base: base)
    recipient_session = insert(:recipient_session, recipient: recipient, session: session)
    %{base: base, recipient: recipient, session: session, recipient_session: recipient_session}
  end
end
