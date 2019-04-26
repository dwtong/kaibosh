export default {
  errors: null,
  loading: false,

  list: [],

  details: {
    name: "",
    id: null,
    status: "",
    primary_contact: {
      name: "",
      email: "",
      mobile: "",
      landline: ""
    },
    base: {
      name: "",
      id: null
    }
  },

  scheduledSessions: [],

  filters: {
    base_id: 0,
    name: "",
    status: [
      { label: "Active", name: "active", enabled: false },
      { label: "Pending", name: "pending", enabled: false },
      { label: "On Hold", name: "on_hold", enabled: false },
      { label: "Archived", name: "archived", enabled: false }
    ]
  }
};
