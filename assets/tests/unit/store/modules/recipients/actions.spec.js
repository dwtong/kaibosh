import actions from "@/store/modules/recipients/actions";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/recipients/state";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const commit = jest.fn();

describe("actions", () => {
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

  describe("resetFilters", () => {
    it("resets name and status filter", async () => {
      const statuses = [...state.filters.status];
      statuses.forEach(f => (f.enabled = false));
      await actions.resetFilters({ commit, state });

      await expect(commit).toBeCalledWith(types.SET_NAME_FILTER, "");
      await expect(commit).toBeCalledWith(types.SET_STATUS_FILTER, statuses);
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
