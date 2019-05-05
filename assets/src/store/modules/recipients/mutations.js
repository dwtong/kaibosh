import * as types from "@/store/mutation-types";

export default {
  [types.API_GET_RECIPIENT.PENDING](state) {
    state.loading = true;
  },

  [types.API_GET_RECIPIENT.SUCCESS](state, payload) {
    state.loading = false;
    state.details = payload;
  },

  [types.API_GET_RECIPIENT.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_GET_RECIPIENTS.PENDING](state) {
    state.loading = true;
  },

  [types.API_GET_RECIPIENTS.SUCCESS](state, payload) {
    state.loading = false;
    state.list = payload;
  },

  [types.API_GET_RECIPIENTS.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_GET_SCHEDULED_SESSIONS.PENDING](state) {
    state.loading = true;
  },

  [types.API_GET_SCHEDULED_SESSIONS.SUCCESS](state, payload) {
    state.loading = false;
    state.scheduledSessions = payload;
  },

  [types.API_GET_SCHEDULED_SESSIONS.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_DELETE_SCHEDULED_SESSION.PENDING](state) {
    state.loading = true;
  },

  [types.API_DELETE_SCHEDULED_SESSION.SUCCESS](state, sessionId) {
    state.loading = false;
    const index = state.scheduledSessions.findIndex(s => s.id == sessionId);
    state.scheduledSessions.splice(index, 1);
  },

  [types.API_DELETE_SCHEDULED_SESSION.FAILURE](state, payload) {
    state.loading = false;
    state.errors = [payload];
  },

  [types.API_CREATE_SCHEDULED_SESSION.PENDING](state) {
    state.loading = true;
    state.errors = null;
  },

  [types.API_CREATE_SCHEDULED_SESSION.SUCCESS](state, payload) {
    state.loading = false;
    state.scheduledSessions.push(payload);
  },

  [types.API_CREATE_SCHEDULED_SESSION.FAILURE](state, payload) {
    state.loading = false;
    state.errors = payload;
  },

  [types.API_CREATE_RECIPIENT.PENDING](state) {
    state.loading = true;
    state.errors = null;
  },

  [types.API_CREATE_RECIPIENT.SUCCESS](state, payload) {
    state.loading = false;
    state.details = payload;
  },

  [types.API_CREATE_RECIPIENT.FAILURE](state, payload) {
    state.loading = false;
    state.errors = payload;
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
