export default {
  filteredRecipients(state) {
    const filters = state.filters.status
      .filter(f => f.enabled)
      .map(f => f.name);

    let list;

    if (!state.list || state.list.length == 0) {
      list = [];
    } else if (filters.length > 0) {
      list = state.list.filter(r => filters.includes(r.status));
    } else {
      list = state.list;
    }

    if (state.filters.name !== "") {
      list = list.filter(r =>
        r.name.toLowerCase().includes(state.filters.name.toLowerCase())
      );
    }

    if (state.filters.base_id !== 0) {
      list = list.filter(r => r.base_id === state.filters.base_id);
    }

    return list;
  }
};
