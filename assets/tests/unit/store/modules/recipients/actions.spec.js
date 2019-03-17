import actions from "@/store/modules/recipients/actions";
import state from "@/store/modules/recipients/state";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const commit = jest.fn();
const recipients = [
  { id: 1, name: "Wellington Food Bank", status: "active" },
  { id: 2, name: "Salvation Army Lower Hutt", status: "active" }
];

describe("actions", () => {
  describe("getAllRecipients", () => {
    it("calls UPDATE_RECIPIENT_LIST mutation with list of recipients on API success", async () => {
      mock.onGet("/api/v1/recipients").reply(200, recipients);
      await actions.getAllRecipients({ commit, state });
      expect(commit).toBeCalledWith("UPDATE_RECIPIENT_LIST", {
        recipients: recipients
      });
    });
  });

  describe("resetFilters", () => {
    it("calls RESET_FILTERS mutation", async () => {
      await actions.resetFilters({ commit, state });
      expect(commit).toBeCalledWith("RESET_FILTERS");
    });
  });

  describe("updateNameFilter", () => {
    it("calls UPDATE_NAME_FILTER mutation with new filter value", async () => {
      const value = "search string";
      await actions.updateNameFilter({ commit, state }, value);
      expect(commit).toBeCalledWith("UPDATE_NAME_FILTER", { value });
    });
  });

  describe("toggleStatusFilter", () => {
    it("calls TOGGLE_STATUS_FILTER mutation with status filter to toggle", async () => {
      const status = "active";
      await actions.toggleStatusFilter({ commit, state }, status);
      expect(commit).toBeCalledWith("TOGGLE_STATUS_FILTER", {
        statusName: status
      });
    });
  });
});
