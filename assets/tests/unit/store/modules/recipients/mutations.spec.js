import mutations from "@/store/modules/recipients/mutations";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/recipients/state";

describe("mutations", () => {
  describe("API_CREATE_RECIPIENT", () => {
    it("PENDING", () => {
      mutations[types.API_CREATE_RECIPIENT.PENDING](state);
      expect(state.activeRecipient.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = { name: "Recipient 1", status: "active", id: 1 };
      mutations[types.API_CREATE_RECIPIENT.SUCCESS](state, payload);
      expect(state.activeRecipient.data).toEqual(payload);
      expect(state.activeRecipient.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      mutations[types.API_CREATE_RECIPIENT.FAILURE](state);
      expect(state.activeRecipient.loading).toBeFalsy;
    });
  });

  describe("API_GET_RECIPIENTS", () => {
    it("PENDING", () => {
      mutations[types.API_GET_RECIPIENTS.PENDING](state);
      expect(state.recipientList.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ name: "Recipient 1", status: "active" }];
      mutations[types.API_GET_RECIPIENTS.SUCCESS](state, payload);
      expect(state.recipientList.data).toEqual(payload);
      expect(state.recipientList.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      mutations[types.API_GET_RECIPIENTS.FAILURE](state);
      expect(state.recipientList.loading).toBeFalsy;
    });
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
