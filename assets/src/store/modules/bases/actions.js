import apiHelper from "@/store/api-helper";
import * as types from "@/store/mutation-types";

export default {
  async getBases(store) {
    await apiHelper.get(store, {
      endpoint: "/bases",
      mutation: types.API_GET_BASES
    });
  },

  async getFoodCategories(store) {
    await apiHelper.get(store, {
      endpoint: "/food-categories",
      mutation: types.API_GET_FOOD_CATEGORIES
    });
  },

  async getSessionSlots(store, baseId) {
    await apiHelper.get(store, {
      endpoint: "/sessions/slots",
      mutation: types.API_GET_SESSION_SLOTS,
      params: { base_id: baseId }
    });
  }
};
