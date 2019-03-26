import mutations from "@/store/modules/bases/mutations";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/bases/state";

describe("mutations", () => {
  describe("API_GET_BASES", () => {
    it("PENDING", () => {
      mutations[types.API_GET_BASES.PENDING](state);
      expect(state.bases.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ name: "Kaibosh Wellington", id: 1 }];
      mutations[types.API_GET_BASES.SUCCESS](state, payload);
      expect(state.bases.data).toEqual(payload);
      expect(state.bases.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      mutations[types.API_GET_BASES.FAILURE](state);
      expect(state.bases.loading).toBeFalsy;
    });
  });
});
