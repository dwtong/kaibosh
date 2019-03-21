import mutations from "@/store/modules/recipients/mutations";
import state from "@/store/modules/recipients/state";

describe("mutations", () => {
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
