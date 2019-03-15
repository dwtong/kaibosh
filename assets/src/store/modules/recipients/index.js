import api from "@/store/api";

const state = {
  recipientList: [],
  filters: {
    name: "",
    status: [
      { label: "Active", name: "active", enabled: false },
      { label: "Pending", name: "pending", enabled: false },
      { label: "On Hold", name: "on_hold", enabled: false },
      { label: "Archived", name: "archived", enabled: false }
    ]
  }
};

const mutations = {
  UPDATE_RECIPIENT_LIST(state, payload) {
    state.recipientList = payload;
  },

  UPDATE_NAME_FILTER(state, value) {
    state.filters.name = value;
  },

  RESET_FILTERS(state) {
    state.filters.name = "";
    state.filters.status.forEach(f => (f.enabled = false));
  },

  TOGGLE_STATUS_FILTER(state, statusName) {
    const filter = state.filters.status.find(f => f.name === statusName);
    filter.enabled = filter.enabled ? false : true;
  }
};

const actions = {
  async getAllRecipients({ commit }) {
    const response = await api.get("/recipients");
    commit("UPDATE_RECIPIENT_LIST", response.data);
  },

  resetFilters({ commit }) {
    commit("RESET_FILTERS");
  },

  updateNameFilter({ commit }, value) {
    commit("UPDATE_NAME_FILTER", value);
  },

  toggleStatusFilter({ commit }, statusName) {
    commit("TOGGLE_STATUS_FILTER", statusName);
  }
};

const getters = {
  filteredRecipientList(state) {
    const activeFilterNames = state.filters.status
      .filter(f => f.enabled)
      .map(f => f.name);

    let recipientList;

    if (activeFilterNames.length > 0 && state.recipientList.length > 0) {
      recipientList = state.recipientList.filter(r =>
        activeFilterNames.includes(r.status)
      );
    } else {
      recipientList = state.recipientList;
    }

    return recipientList.filter(r => r.name.includes(state.filters.name));
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions,
  getters
};
