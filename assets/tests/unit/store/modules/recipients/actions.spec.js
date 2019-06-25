import actions from "@/store/modules/recipients/actions";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/recipients/state";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const commit = jest.fn();

describe("actions", () => {
  describe("createRecipient", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const recipient = { recipient: { name: "Test 1" } };
      const createdRecipient = { ...recipient, id: 1 };
      mock.onPost("/api/v1/recipients").reply(201, createdRecipient);
      await actions.createRecipient({ commit, state }, recipient);
      await expect(commit).toBeCalledWith(types.API_CREATE_RECIPIENT.PENDING);
      await expect(commit).toBeCalledWith(
        types.API_CREATE_RECIPIENT.SUCCESS,
        createdRecipient
      );
    });
  });

  describe("createScheduledSession", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const session = {
        session: {
          session_slot_id: 1,
          recipient_id: 1,
          allocations_attributes: [
            {
              food_category_id: 1,
              quantity: null
            }
          ]
        }
      };
      const createdSession = { ...session, id: 1 };
      mock.onPost("/api/v1/sessions/scheduled").reply(201, createdSession);
      await actions.createScheduledSession({ commit, state }, session);
      await expect(commit).toBeCalledWith(
        types.API_CREATE_SCHEDULED_SESSION.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_CREATE_SCHEDULED_SESSION.SUCCESS,
        createdSession
      );
    });
  });

  describe("createSessionHold", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const sessionHold = {
        session_hold: {
          scheduled_session_id: 1,
          starts_at: "2019-01-01",
          ends_at: "2020-01-01"
        }
      };
      const createdSessionHold = { ...sessionHold, id: 1 };
      mock.onPost("/api/v1/sessions/holds").reply(201, createdSessionHold);
      await actions.createSessionHold({ commit, state }, sessionHold);
      await expect(commit).toBeCalledWith(
        types.API_CREATE_SESSION_HOLD.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_CREATE_SESSION_HOLD.SUCCESS,
        createdSessionHold
      );
    });
  });

  describe("updateScheduledSession", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const session = {
        id: 1,
        session_slot_id: 1,
        recipient_id: 1,
        allocations_attributes: [
          {
            food_category_id: 1,
            quantity: null
          }
        ]
      };
      mock
        .onPut(`/api/v1/sessions/scheduled/${session.id}`)
        .reply(200, session);
      await actions.updateScheduledSession({ commit, state }, session);
      await expect(commit).toBeCalledWith(
        types.API_UPDATE_SCHEDULED_SESSION.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_UPDATE_SCHEDULED_SESSION.SUCCESS,
        session
      );
    });
  });

  describe("deleteScheduledSession", () => {
    it("calls SUCCESS mutation with session to delete on API success", async () => {
      const sessionId = 1;
      mock.onDelete(`/api/v1/sessions/scheduled/${sessionId}`).reply(204, "");
      await actions.deleteScheduledSession({ commit, state }, sessionId);
      await expect(commit).toBeCalledWith(
        types.API_DELETE_SCHEDULED_SESSION.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_DELETE_SCHEDULED_SESSION.SUCCESS,
        sessionId
      );
    });
  });

  describe("deleteSessionHold", () => {
    it("calls SUCCESS mutation with session to delete on API success", async () => {
      const sessionHoldId = 1;
      mock.onDelete(`/api/v1/sessions/holds/${sessionHoldId}`).reply(204, "");
      await actions.deleteSessionHold({ commit, state }, sessionHoldId);
      await expect(commit).toBeCalledWith(
        types.API_DELETE_SESSION_HOLD.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_DELETE_SESSION_HOLD.SUCCESS,
        sessionHoldId
      );
    });
  });

  describe("getRecipients", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const recipients = [
        { name: "Test 1", status: "active" },
        { name: "Test 2", status: "pending" }
      ];
      mock.onGet("/api/v1/recipients").reply(200, recipients);
      await actions.getRecipients({ commit, state });
      await expect(commit).toBeCalledWith(types.API_GET_RECIPIENTS.PENDING);
      await expect(commit).toBeCalledWith(
        types.API_GET_RECIPIENTS.SUCCESS,
        recipients
      );
    });
  });

  describe("getScheduledSessions", () => {
    it("calls SUCCESS mutation with list of recipients on API success", async () => {
      const recipient_id = 1;
      const sessions = [
        { id: 1, recipient_id: recipient_id, session_slot_id: 1 },
        { id: 2, recipient_id: recipient_id, session_slot_id: 2 }
      ];
      mock
        .onGet("/api/v1/sessions/scheduled", {
          params: { recipient_id: recipient_id }
        })
        .reply(200, sessions);
      await actions.getScheduledSessions({ commit, state }, recipient_id);
      await expect(commit).toBeCalledWith(
        types.API_GET_SCHEDULED_SESSIONS.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_GET_SCHEDULED_SESSIONS.SUCCESS,
        sessions
      );
    });
  });

  describe("resetFilters", () => {
    it("resets name and status filter", async () => {
      const statuses = [...state.filters.status];
      statuses.forEach(f => (f.enabled = false));
      await actions.resetFilters({ commit, state });

      await expect(commit).toBeCalledWith(types.SET_BASE_FILTER, 0);
      await expect(commit).toBeCalledWith(types.SET_NAME_FILTER, "");
      await expect(commit).toBeCalledWith(types.SET_STATUS_FILTER, statuses);
    });
  });

  describe("updateBaseFilter", () => {
    it("updates base filter with new value", async () => {
      const value = 1;
      await actions.updateBaseFilter({ commit, state }, value);

      expect(commit).toBeCalledWith(types.SET_BASE_FILTER, value);
    });
  });

  describe("updateNameFilter", () => {
    it("updates name filter with new value", async () => {
      const value = "search string";
      await actions.updateNameFilter({ commit, state }, value);

      expect(commit).toBeCalledWith(types.SET_NAME_FILTER, value);
    });
  });

  describe("toggleStatusFilter", () => {
    it("enables provided status filter", async () => {
      const statuses = [...state.filters.status];
      const filter = statuses.find(f => f.name === "active");
      filter.enabled = true;
      await actions.toggleStatusFilter({ commit, state }, "active");

      expect(commit).toBeCalledWith(types.SET_STATUS_FILTER, statuses);
    });
  });
});
