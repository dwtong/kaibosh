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

  #
  # describe "plan for session" do
  #   setup [:create_session_with_recipients_and_allocations]
  #
  #   test "session includes calculated session date"
  #   test "recipients that have not started are excluded from plan"
  #   test "recipients that are archived are excluded from plan"
  #   test "recipients that have not completed onboarding are excluded from plan"
  #   test "recipients that are active and on hold are included in plan"
  #   test "includes allocation details"
  # end

  describe "session plans for week" do
    setup [:create_sessions_with_recipients]

    test "session includes calculated session date", %{base: base} do
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

    test "recipients that have not started are excluded from plan", %{
      base: %{id: base_id},
      not_started_recipient: %{id: not_started_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == not_started_recipient_id))
    end

    test "recipients that are archived are excluded from plan", %{
      base: %{id: base_id},
      archived_recipient: %{id: archived_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == archived_recipient_id))
    end

    test "recipients that have not completed onboarding are excluded from plan", %{
      base: %{id: base_id},
      incomplete_recipient: %{id: incomplete_recipient_id}
    } do
      [%{recipients: recipients}] = Sessions.list_plans_for_base_and_week(base_id, ~D[2020-08-03])
      refute Enum.find(recipients, &(&1.id == incomplete_recipient_id))
    end

    test "recipients that are active and on hold are included in plan", %{
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

  defp create_sessions_with_recipients(_) do
    base = insert(:base)
    session = insert(:session, base: base, day: "wednesday")

    %{recipient: archived_recipient} =
      insert(:recipient_session,
        recipient: insert(:recipient, archived_at: ~U[2019-01-01T00:00:00Z], base: base),
        session: session
      )

    %{recipient: not_started_recipient} =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base, started_at: tomorrow()),
        session: session
      )

    %{recipient: incomplete_recipient} =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base, met_kaibosh_at: nil, signed_terms_at: nil),
        session: session
      )

    %{recipient: active_recipient} =
      insert(:recipient_session,
        recipient: insert(:recipient, base: base),
        session: session
      )

    %{recipient: on_hold_recipient} =
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
      incomplete_recipient: incomplete_recipient
    }
  end
end
