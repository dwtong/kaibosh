import * as types from "@/store/mutation-types";

export default {
  UPDATE_RECIPIENT_LIST(state, payload) {
    state.recipientList = payload;
  },

  [types.SET_NAME_FILTER](state, payload) {
    state.filters.name = payload;
  },

  [types.SET_STATUS_FILTER](state, payload) {
    state.filters.status = payload;
  }
};
