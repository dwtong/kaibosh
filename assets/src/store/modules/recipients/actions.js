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

  async getRecipients(store) {
    await apiHelper.get(store, {
      endpoint: "/recipients",
      mutation: types.API_GET_RECIPIENTS
    });
  },

  async resetFilters({ commit, state }) {
    const statusFilter = [...state.filters.status];
    statusFilter.forEach(f => (f.enabled = false));

    await commit(types.SET_NAME_FILTER, "");
    await commit(types.SET_STATUS_FILTER, statusFilter);
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
