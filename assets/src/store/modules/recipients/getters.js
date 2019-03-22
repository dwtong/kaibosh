import * as types from "@/store/mutation-types";

export default {
  filteredRecipients(state) {
    const filters = state.filters.status
      .filter(f => f.enabled)
      .map(f => f.name);

    const data = state.recipientList.data;
    let recipientList;

    if (!data || data.length == 0) {
      recipientList = [];
    } else if (filters.length > 0) {
      recipientList = data.filter(r => filters.includes(r.status));
    } else {
      recipientList = data;
    }

    return recipientList.filter(r =>
      r.name.toLowerCase().includes(state.filters.name.toLowerCase())
    );
  }
};
