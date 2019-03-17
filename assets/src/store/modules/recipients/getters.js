export default {
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

    return recipientList.filter(r =>
      r.name.toLowerCase().includes(state.filters.name.toLowerCase())
    );
  }
};
