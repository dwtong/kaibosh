import mutations from "@/store/modules/bases/mutations";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/bases/state";

describe("mutations", () => {
  describe("API_GET_BASES", () => {
    it("PENDING", () => {
      mutations[types.API_GET_BASES.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ name: "Kaibosh Wellington", id: 1 }];
      mutations[types.API_GET_BASES.SUCCESS](state, payload);
      expect(state.list).toEqual(payload);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = "api failure";
      mutations[types.API_GET_BASES.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual([payload]);
    });
  });

  describe("API_GET_FOOD_CATEGORIES", () => {
    it("PENDING", () => {
      mutations[types.API_GET_FOOD_CATEGORIES.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ name: "Bananas", id: 1 }];
      mutations[types.API_GET_FOOD_CATEGORIES.SUCCESS](state, payload);
      expect(state.foodCategories).toEqual(payload);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = "api failure";
      mutations[types.API_GET_FOOD_CATEGORIES.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual([payload]);
    });
  });

  describe("API_GETSESSION_SLOTS", () => {
    it("PENDING", () => {
      mutations[types.API_GET_SESSION_SLOTS.PENDING](state);
      expect(state.loading).toBeTruthy;
    });

    it("SUCCESS", () => {
      const payload = [{ day: "Wednesday", time: "10:00 AM", id: 1 }];
      mutations[types.API_GET_SESSION_SLOTS.SUCCESS](state, payload);
      expect(state.sessionSlots).toEqual(payload);
      expect(state.loading).toBeFalsy;
    });

    it("FAILURE", () => {
      const payload = "api failure";
      mutations[types.API_GET_SESSION_SLOTS.FAILURE](state, payload);
      expect(state.loading).toBeFalsy;
      expect(state.errors).toEqual([payload]);
    });
  });
});
