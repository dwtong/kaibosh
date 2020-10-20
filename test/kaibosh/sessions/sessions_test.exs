defmodule Kaibosh.SessionsTest do
  use Kaibosh.DataCase

  alias Kaibosh.Sessions
  alias Kaibosh.Sessions.Session

  describe "managing sessions for base" do
    @valid_attrs %{day: "some day", time: ~T[00:00:00]}
    @update_attrs %{day: "some updated day", time: ~T[12:00:00]}
    @invalid_attrs %{day: nil, time: nil}

    test "listing session times returns all session times for base" do
      session = insert(:session) |> Repo.forget(:base)
      assert Sessions.list_session_times_for_base(session.base_id) == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = insert(:session) |> Repo.forget(:base)
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      base = insert(:base)
      attrs = Map.put(@valid_attrs, :base_id, base.id)
      assert {:ok, %Session{} = session} = Sessions.create_session(attrs)
      assert session.day == "some day"
      assert session.time == @valid_attrs.time
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:ok, %Session{} = session} = Sessions.update_session(session, @update_attrs)
      assert session.day == "some updated day"
      assert session.time == @update_attrs.time
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = insert(:session) |> Repo.forget(:base)
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = insert(:session) |> Repo.forget(:base)
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end

  describe "plan for session" do
    setup [:create_session_with_recipients, :create_allocations]

    test "session plan includes calculated session date", %{base: base} do
      session = insert(:session, day: "tuesday", base: base)

      assert %{session: %{date: ~D[2020-08-04]}} =
               Sessions.get_plan_for_session(session.id, ~D[2020-08-03])
    end

    test "includes sessions that have no recipients", %{base: base} do
      session = insert(:session, day: "tuesday", base: base)
      assert %{recipients: []} = Sessions.get_plan_for_session(session.id, ~D[2020-08-03])
    end

    test "recipients that have not started are excluded from plan", %{
      not_started_recipient: %{id: not_started_recipient_id},
      session: session
    } do
      %{recipients: recipients, allocations: allocations} =
        Sessions.get_plan_for_session(session.id, ~D[2020-08-03])

      refute Enum.find(recipients, &(&1.id == not_started_recipient_id))
      refute Enum.find(allocations, &(&1.recipient_id == not_started_recipient_id))
    end

    test "recipients that are archived are excluded from plan", %{
      archived_recipient: %{id: archived_recipient_id},
      session: session
    } do
      %{recipients: recipients, allocations: allocations} =
        Sessions.get_plan_for_session(session.id, ~D[2020-08-03])

      refute Enum.find(recipients, &(&1.id == archived_recipient_id))
      refute Enum.find(allocations, &(&1.recipient_id == archived_recipient_id))
    end

    test "recipients that have not completed onboarding are excluded from plan", %{
      incomplete_recipient: %{id: incomplete_recipient_id},
      session: session
    } do
      %{recipients: recipients, allocations: allocations} =
        Sessions.get_plan_for_session(session.id, ~D[2020-08-03])

      refute Enum.find(recipients, &(&1.id == incomplete_recipient_id))
      refute Enum.find(allocations, &(&1.recipient_id == incomplete_recipient_id))
    end

    test "recipients that are active and on hold are included in plan", %{
      active_recipient: %{id: active_recipient_id},
      on_hold_recipient: %{id: on_hold_recipient_id},
      session: session
    } do
      %{recipients: recipients} = Sessions.get_plan_for_session(session.id, ~D[2020-08-03])

      assert length(recipients) == 2

      assert %{id: ^active_recipient_id, status: :active} =
               Enum.find(recipients, &(&1.id == active_recipient_id))

      assert %{id: ^on_hold_recipient_id, status: :on_hold} =
               Enum.find(recipients, &(&1.id == on_hold_recipient_id))
    end

    test "lists categories with recipients allocations", %{
      active_recipient_session: recipient_session,
      a1: expected_a1,
      a2: expected_a2
    } do
      session_id = recipient_session.session_id

      assert %{session: _session, allocations: [a1, a2], recipients: [r1, r2]} =
               Sessions.get_plan_for_session(session_id, ~D[2020-01-01])

      assert r1.id == recipient_session.recipient.id
      assert r1.name == recipient_session.recipient.name
      assert r1.status == :active
      assert r2.status == :on_hold

      assert a1.category_id == expected_a1.category_id
      assert a2.category_id == expected_a2.category_id
      assert Decimal.to_integer(a1.quantity) == 5
      assert Decimal.to_integer(a2.quantity) == 2
      assert a1.recipient_id == r1.id
      assert a2.recipient_id == r2.id
    end
  end

  describe "session plans for week" do
    setup [:create_session_with_recipients]

    test "session list includes calculated session date", %{base: base} do
      session = insert(:session, day: "tuesday", base: base)

      # 2020-08-03 is a monday
      sessions = Sessions.list_plans_for_base_and_week(base.id, ~D[2020-08-03])

      # 2020-08-04 is the tuesday - as per created session
      assert %{session: %{date: ~D[2020-08-04]}} =
               Enum.find(sessions, &(&1.session.id == session.id))

      # other session is the wednesday
      assert %{session: %{date: ~D[2020-08-05]}} =
               Enum.find(sessions, &(&1.session.id != session.id))
    end

    test "includes sessions that have no recipients", %{base: base} do
      session = insert(:session, day: "tuesday", base: base)
      sessions = Sessions.list_plans_for_base_and_week(base.id, ~D[2020-08-03])
      assert %{recipients: []} = Enum.find(sessions, &(&1.session.id == session.id))
    end

    test "recipients that have not started are excluded from plans", %{
      base: %{id: base_id},
      not_started_recipient: %{id: not_started_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == not_started_recipient_id))
    end

    test "recipients that are archived are excluded from plans", %{
      base: %{id: base_id},
      archived_recipient: %{id: archived_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == archived_recipient_id))
    end

    test "recipients that have not completed onboarding are excluded from plans", %{
      base: %{id: base_id},
      incomplete_recipient: %{id: incomplete_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == incomplete_recipient_id))
    end

    test "recipients that are active and on hold are included in plans", %{
      active_recipient: %{id: active_recipient_id},
      on_hold_recipient: %{id: on_hold_recipient_id},
      base: %{id: base_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])

      assert length(recipients) == 2

      assert %{id: ^active_recipient_id, status: :active} =
               Enum.find(recipients, &(&1.id == active_recipient_id))

      assert %{id: ^on_hold_recipient_id, status: :on_hold} =
               Enum.find(recipients, &(&1.id == on_hold_recipient_id))
    end
  end

  defp create_session_with_recipients(_) do
    base = insert(:base)
    session = insert(:session, base: base, day: "wednesday")

    %{recipient: archived_recipient} =
      archived_recipient_session =
      insert(:recipient_session,
        recipient: insert(:recipient, archived_at: ~U[2019-01-01T00:00:00Z], base: base),
        session: session
      )

    %{recipient: not_started_recipient} =
      not_started_recipient_session =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base, started_at: tomorrow()),
        session: session
      )

    %{recipient: incomplete_recipient} =
      incomplete_recipient_session =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base, met_kaibosh_at: nil, signed_terms_at: nil),
        session: session
      )

    %{recipient: active_recipient} =
      active_recipient_session =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base),
        session: session
      )

    %{recipient: on_hold_recipient} =
      on_hold_recipient_session =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base),
        session: session,
        holds: [insert(:hold)]
      )

    %{
      base: base,
      on_hold_recipient: on_hold_recipient,
      active_recipient: active_recipient,
      archived_recipient: archived_recipient,
      not_started_recipient: not_started_recipient,
      incomplete_recipient: incomplete_recipient,
      session: session,
      active_recipient_session: active_recipient_session,
      archived_recipient_session: archived_recipient_session,
      not_started_recipient_session: not_started_recipient_session,
      on_hold_recipient_session: on_hold_recipient_session,
      incomplete_recipient_session: incomplete_recipient_session
    }
  end

  def create_allocations(%{
        active_recipient_session: active_recipient_session,
        archived_recipient_session: archived_recipient_session,
        not_started_recipient_session: not_started_recipient_session,
        on_hold_recipient_session: on_hold_recipient_session,
        incomplete_recipient_session: incomplete_recipient_session
      }) do
    apples = insert(:category, name: "apples")
    bananas = insert(:category, name: "bananas")

    insert(:allocation,
      recipient_session: not_started_recipient_session,
      category: apples,
      quantity: 5
    )

    insert(:allocation,
      recipient_session: incomplete_recipient_session,
      category: apples,
      quantity: 5
    )

    insert(:allocation,
      recipient_session: archived_recipient_session,
      category: apples,
      quantity: 5
    )

    a1 =
      insert(:allocation,
        recipient_session: active_recipient_session,
        category: apples,
        quantity: 5
      )

    a2 =
      insert(:allocation,
        recipient_session: on_hold_recipient_session,
        category: bananas,
        quantity: 2
      )

    %{a1: a1, a2: a2}
  end
end
