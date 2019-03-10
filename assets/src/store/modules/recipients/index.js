import api from "@/store/api";

const state = {
  recipients: ["xxx"]
};

const mutations = {
  UPDATE_ALL_RECIPIENTS(state, payload) {
    state.recipients = payload;
  }
};

const actions = {
  async getAllRecipients({ commit }) {
    const response = await api.get("/recipients");
    commit("UPDATE_ALL_RECIPIENTS", response.data);
  }
};

const getters = {
  recipients: state => state.recipients
};

export default {
  state,
  mutations,
  actions,
  getters
};
