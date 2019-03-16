import mutations from "@/store/modules/recipients/mutations";
import state from "@/store/modules/recipients/state";

const {
  UPDATE_RECIPIENT_LIST,
  UPDATE_NAME_FILTER,
  RESET_FILTERS,
  TOGGLE_STATUS_FILTER
} = mutations;

describe("mutations", () => {
  it("UPDATE_RECIPIENT_LIST", () => {
    const payload = {
      recipients: [{ name: "recipient 1" }, { name: "recipient 2" }]
    };

    UPDATE_RECIPIENT_LIST(state, payload);
    expect(state.recipientList).toEqual(payload.recipients);
  });

  it("UPDATE_NAME_FILTER", () => {
    const payload = { value: "search string" };
    UPDATE_NAME_FILTER(state, payload);
    expect(state.filters.name).toEqual(payload.value);
  });

  it("RESET_FILTERS", () => {
    const state = {
      filters: {
        name: "string",
        status: [{ name: "active", enabled: true }]
      }
    };

    RESET_FILTERS(state);
    expect(state.filters.name).toEqual("");
    expect(state.filters.status[0].enabled).toBeFalsy;
  });

  it("TOGGLE_STATUS_FILTER", () => {
    const activeFilter = state.filters.status.find(f => f.name === "active");
    const payload = {
      statusName: "active"
    };

    expect(activeFilter.enabled).toBeFalsy();
    TOGGLE_STATUS_FILTER(state, payload);
    expect(activeFilter.enabled).toBeTruthy();
  });
});
