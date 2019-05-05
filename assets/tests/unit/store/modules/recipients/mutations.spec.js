import mutations from "@/store/modules/recipients/mutations";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/recipients/state";

describe("mutations", () => {
  describe("API_CREATE_RECIPIENT", () => {
    it("PENDING", () => {
      mutations[types.API_CREATE_RECIPIENT.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = { name: "Recipient 1", status: "active", id: 1 };
      mutations[types.API_CREATE_RECIPIENT.SUCCESS](state, payload);
      expect(state.details).toEqual(payload);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = [{ recipient: ["failed to create"] }];
      mutations[types.API_CREATE_RECIPIENT.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual(payload);
    });
  });

  describe("API_CREATE_SCHEDULED_SESSION", () => {
    it("PENDING", () => {
      mutations[types.API_CREATE_SCHEDULED_SESSION.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = { session_slot_id: 1, recipient_id: 1, id: 1 };
      mutations[types.API_CREATE_SCHEDULED_SESSION.SUCCESS](state, payload);

      expect(state.scheduledSessions).toEqual([payload]);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = [{ recipient: ["failed to create"] }];
      mutations[types.API_CREATE_SCHEDULED_SESSION.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual(payload);
    });
  });

  describe("API_DELETE_SCHEDULED_SESSION", () => {
    it("PENDING", () => {
      mutations[types.API_DELETE_SCHEDULED_SESSION.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const state = { scheduledSessions: [{ id: 1 }, { id: 2 }] };
      mutations[types.API_DELETE_SCHEDULED_SESSION.SUCCESS](state, 1);

      expect(state.scheduledSessions).toEqual([{ id: 2 }]);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = { session: ["failed to delete"] };
      mutations[types.API_DELETE_SCHEDULED_SESSION.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual([payload]);
    });
  });

  describe("API_GET_RECIPIENTS", () => {
    it("PENDING", () => {
      mutations[types.API_GET_RECIPIENTS.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ name: "Recipient 1", status: "active" }];
      mutations[types.API_GET_RECIPIENTS.SUCCESS](state, payload);
      expect(state.list).toEqual(payload);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = "error on get request";
      mutations[types.API_GET_RECIPIENTS.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual([payload]);
    });
  });

  it("SET_BASE_FILTER", () => {
    const payload = 1;
    mutations.SET_BASE_FILTER(state, payload);
    expect(state.filters.base_id).toEqual(payload);
  });

  it("SET_NAME_FILTER", () => {
    const payload = "search string";
    mutations.SET_NAME_FILTER(state, payload);
    expect(state.filters.name).toEqual(payload);
  });

  it("SET_STATUS_FILTER", () => {
    const payload = [{ name: "active", enabled: false }];
    mutations.SET_STATUS_FILTER(state, payload);
    expect(state.filters.status).toEqual(payload);
  });
});
