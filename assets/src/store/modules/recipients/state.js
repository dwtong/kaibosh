export default {
  recipientList: {
    loading: false,
    data: []
  },
  activeRecipient: {
    loading: false,
    data: {},
    errors: null
  },
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
