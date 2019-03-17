export default {
  UPDATE_RECIPIENT_LIST(state, payload) {
    state.recipientList = payload.recipients;
  },

  UPDATE_NAME_FILTER(state, payload) {
    state.filters.name = payload.value;
  },

  RESET_FILTERS(state) {
    state.filters.name = "";
    state.filters.status.forEach(f => (f.enabled = false));
  },

  TOGGLE_STATUS_FILTER(state, payload) {
    const filter = state.filters.status.find(
      f => f.name === payload.statusName
    );
    filter.enabled = filter.enabled ? false : true;
  }
};
