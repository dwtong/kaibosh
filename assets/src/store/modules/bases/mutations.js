import * as types from "@/store/mutation-types";

export default {
  [types.API_GET_BASES.PENDING](state) {
    state.bases.loading = true;
  },

  [types.API_GET_BASES.SUCCESS](state, payload) {
    state.bases.loading = false;
    state.bases.data = payload;
  },

  [types.API_GET_BASES.FAILURE](state) {
    state.bases.loading = false;
  }
};
