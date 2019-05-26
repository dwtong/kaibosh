import getters from "@/store/modules/recipients/getters";
const recipientsList = [
  { id: 1, name: "Wellington Food Bank", status: "active", base_id: 1 },
  { id: 2, name: "Salvation Army Lower Hutt", status: "archived", base_id: 2 },
  { id: 2, name: "Bellyful Lower Hutt", status: "pending", base_id: 3 }
];

describe("getters", () => {
  describe("filteredRecipients", () => {
    test("filters recipients by status", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 0,
          name: "",
          status: [{ name: "active", enabled: true }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([recipientsList[0]]);
    });

    test("filters recipients by base", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 3,
          name: "",
          status: [{ name: "active", enabled: false }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([recipientsList[2]]);
    });

    test("filters recipients by name", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 0,
          name: "army",
          status: [{ name: "active", enabled: false }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([recipientsList[1]]);
    });

    test("filters recipients by all types", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 1,
          name: "Welling",
          status: [{ name: "active", enabled: true }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([recipientsList[0]]);
    });

    test("does not filter recipients if no filters are set", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 0,
          name: "",
          status: [{ name: "active", enabled: false }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual(recipientsList);
    });

    test("returns empty array for no match", () => {
      const state = {
        list: recipientsList,
        filters: {
          base_id: 0,
          name: "xxx",
          status: [{ name: "pending", enabled: true }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([]);
    });
  });

  describe("scheduledSessionById", () => {
    const scheduledSessions = [
      { id: 1, day: "tuesday", time: "10:00 AM" },
      { id: 2, day: "tuesday", time: "12:00 PM" },
      { id: 3, day: "tuesday", time: "6:00 PM" }
    ];

    test("returns scheduledSession for id", () => {
      const state = { scheduledSessions };
      const foodCategory = getters.scheduledSessionById(state)(2);
      expect(foodCategory).toEqual(scheduledSessions[1]);
    });
  });

  describe("categoriesForScheduledSession", () => {
    const scheduledSessions = [
      {
        id: 1,
        day: "tuesday",
        time: "10:00 AM",
        allocations: [
          {
            food_category_id: 3,
            id: 70,
            quantity: "0.0",
            quantity_label: "no boxes"
          }
        ]
      }
    ];

    test("returns scheduledSession for id", () => {
      const state = { scheduledSessions };
      const foodCategory = getters.scheduledSessionById(state)(2);
      expect(foodCategory).toEqual(scheduledSessions[1]);
    });
  });
});
