import api from "@/store/api";

export default {
  async getAllRecipients({ commit }) {
    // TODO handle failure
    const response = await api.get("/recipients");
    commit("UPDATE_RECIPIENT_LIST", { recipients: response.data });
  },

  resetFilters({ commit }) {
    commit("RESET_FILTERS");
  },

  updateNameFilter({ commit }, value) {
    commit("UPDATE_NAME_FILTER", { value });
  },

  toggleStatusFilter({ commit }, statusName) {
    commit("TOGGLE_STATUS_FILTER", { statusName });
  }
};
