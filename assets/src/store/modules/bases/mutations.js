import * as types from "@/store/mutation-types";

export default {
  [types.API_GET_BASES.PENDING](state) {
    state.loading = true;
  },
  [types.API_GET_SESSION_SLOTS.PENDING](state) {
    state.loading = true;
  },
  [types.API_GET_FOOD_CATEGORIES.PENDING](state) {
    state.loading = true;
  },

  [types.API_GET_BASES.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_GET_SESSION_SLOTS.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_GET_FOOD_CATEGORIES.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_GET_BASES.SUCCESS](state, payload) {
    state.loading = false;
    state.list = payload;
  },

  [types.API_GET_SESSION_SLOTS.SUCCESS](state, payload) {
    state.loading = false;
    state.sessionSlots = payload;
  },

  [types.API_GET_FOOD_CATEGORIES.SUCCESS](state, payload) {
    state.loading = false;
    state.foodCategories = payload;
  }
};
