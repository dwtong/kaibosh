import * as types from "@/store/mutation-types";

export default {
  [types.API_GET_RECIPIENTS.PENDING](state) {
    state.recipientList.loading = true;
  },

  [types.API_GET_RECIPIENTS.SUCCESS](state, payload) {
    state.recipientList.loading = false;
    state.recipientList.data = payload;
  },

  [types.API_GET_RECIPIENTS.FAILURE](state) {
    state.recipientList.loading = false;
  },

  [types.SET_NAME_FILTER](state, payload) {
    state.filters.name = payload;
  },

  [types.SET_STATUS_FILTER](state, payload) {
    state.filters.status = payload;
  }
};
