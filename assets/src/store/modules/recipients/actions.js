import apiHelper from "@/store/api-helper";
import * as types from "@/store/mutation-types";

export default {
  async createRecipient(store, recipient) {
    recipient.primary_contact_attributes = recipient.primary_contact;

    await apiHelper.post(store, {
      endpoint: "/recipients",
      body: recipient,
      mutation: types.API_CREATE_RECIPIENT
    });
  },

  async createScheduledSession(store, session) {
    await apiHelper.post(store, {
      endpoint: "/sessions/scheduled",
      body: { session },
      mutation: types.API_CREATE_SCHEDULED_SESSION
    });
  },

  async createSessionHold(store, sessionHold) {
    await apiHelper.post(store, {
      endpoint: "/sessions/holds",
      body: { session_hold: sessionHold },
      mutation: types.API_CREATE_SESSION_HOLD
    });
  },

  async updateScheduledSession(store, session) {
    await apiHelper.put(store, {
      endpoint: `/sessions/scheduled/${session.id}`,
      body: { session },
      mutation: types.API_UPDATE_SCHEDULED_SESSION
    });
  },

  async deleteScheduledSession(store, sessionId) {
    await apiHelper.del(store, {
      endpoint: "/sessions/scheduled",
      id: sessionId,
      mutation: types.API_DELETE_SCHEDULED_SESSION
    });
  },

  async deleteSessionHold(store, sessionHoldId) {
    await apiHelper.del(store, {
      endpoint: "/sessions/holds",
      id: sessionHoldId,
      mutation: types.API_DELETE_SESSION_HOLD
    });
  },

  async getScheduledSessions(store, recipientId) {
    await apiHelper.get(store, {
      endpoint: "/sessions/scheduled",
      mutation: types.API_GET_SCHEDULED_SESSIONS,
      params: { recipient_id: recipientId }
    });
  },

  async getRecipients(store) {
    await apiHelper.get(store, {
      endpoint: "/recipients",
      mutation: types.API_GET_RECIPIENTS
    });
  },

  async getRecipient(store, id) {
    await apiHelper.get(store, {
      endpoint: `/recipients/${id}`,
      mutation: types.API_GET_RECIPIENT
    });
  },

  async resetFilters({ commit, state }) {
    const statusFilter = [...state.filters.status];
    statusFilter.forEach(f => (f.enabled = false));

    await commit(types.SET_BASE_FILTER, 0);
    await commit(types.SET_NAME_FILTER, "");
    await commit(types.SET_STATUS_FILTER, statusFilter);
  },

  updateBaseFilter({ commit }, value) {
    commit(types.SET_BASE_FILTER, value);
  },

  updateNameFilter({ commit }, value) {
    commit(types.SET_NAME_FILTER, value);
  },

  toggleStatusFilter({ commit, state }, statusName) {
    const statusFilter = [...state.filters.status];
    const filter = statusFilter.find(f => f.name === statusName);
    filter.enabled = filter.enabled ? false : true;

    commit(types.SET_STATUS_FILTER, statusFilter);
  }
};
