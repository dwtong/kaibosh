import * as types from "@/store/mutation-types";

export default {
  [types.API_GET_RECIPIENT.PENDING](state) {
    state.activeRecipient.loading = true;
    state.activeRecipient.data = {};
  },

  [types.API_GET_RECIPIENT.SUCCESS](state, payload) {
    state.activeRecipient.loading = false;
    state.activeRecipient.data = payload;
  },

  [types.API_GET_RECIPIENT.FAILURE](state) {
    state.activeRecipient.loading = false;
  },

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

  [types.API_CREATE_RECIPIENT.PENDING](state) {
    state.activeRecipient.loading = true;
    state.activeRecipient.errors = null;
  },

  [types.API_CREATE_RECIPIENT.SUCCESS](state, payload) {
    state.activeRecipient.loading = false;
    state.activeRecipient.data = payload;
  },

  [types.API_CREATE_RECIPIENT.FAILURE](state, payload) {
    state.activeRecipient.loading = false;
    state.activeRecipient.errors = payload;
  },

  [types.SET_BASE_FILTER](state, payload) {
    state.filters.base_id = payload;
  },

  [types.SET_NAME_FILTER](state, payload) {
    state.filters.name = payload;
  },

  [types.SET_STATUS_FILTER](state, payload) {
    state.filters.status = payload;
  }
};
