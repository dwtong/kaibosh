import actions from "@/store/modules/bases/actions";
import * as types from "@/store/mutation-types";
import state from "@/store/modules/bases/state";
import axios from "axios";
import MockAdapter from "axios-mock-adapter";
const mock = new MockAdapter(axios);
const commit = jest.fn();

describe("actions", () => {
  describe("getBases", () => {
    it("calls SUCCESS mutation with list of bases on API success", async () => {
      const bases = [
        { name: "Kaibosh Wellington", id: 1 },
        { name: "Kaibosh Hutt", id: 2 }
      ];
      mock.onGet("/api/v1/bases").reply(200, bases);
      await actions.getBases({ commit, state });
      await expect(commit).toBeCalledWith(types.API_GET_BASES.PENDING);
      await expect(commit).toBeCalledWith(types.API_GET_BASES.SUCCESS, bases);
    });
  });

  describe("getFoodCategories", () => {
    it("calls SUCCESS mutation with list of food categories on API success", async () => {
      const foodCategories = [
        { name: "bananas", id: 1 },
        { name: "bread", id: 2 }
      ];
      mock.onGet("/api/v1/food-categories").reply(200, foodCategories);
      await actions.getFoodCategories({ commit, state });
      await expect(commit).toBeCalledWith(
        types.API_GET_FOOD_CATEGORIES.PENDING
      );
      await expect(commit).toBeCalledWith(
        types.API_GET_FOOD_CATEGORIES.SUCCESS,
        foodCategories
      );
    });
  });

  describe("getSessionSlots", () => {
    it("calls SUCCESS mutation with list of food categories on API success", async () => {
      const baseId = 1;
      const sessionSlots = [
        { day: "Monday", time: "10:00 AM", id: 1 },
        { day: "Wednesday", time: "12:00 PM", id: 2 }
      ];
      mock
        .onGet(`/api/v1/sessions/slots?base_id=${baseId}`)
        .reply(200, sessionSlots);
      await actions.getSessionSlots({ commit, state }, baseId);
      await expect(commit).toBeCalledWith(types.API_GET_SESSION_SLOTS.PENDING);
      await expect(commit).toBeCalledWith(
        types.API_GET_SESSION_SLOTS.SUCCESS,
        sessionSlots
      );
    });
  });
});
