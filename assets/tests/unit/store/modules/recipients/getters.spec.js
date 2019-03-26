import getters from "@/store/modules/recipients/getters";
const getRecipientsData = [
  { id: 1, name: "Wellington Food Bank", status: "active" },
  { id: 2, name: "Salvation Army Lower Hutt", status: "archived" }
];

describe("getters", () => {
  describe("filteredRecipients", () => {
    test("filters recipients by status", () => {
      const state = {
        recipientList: { data: getRecipientsData, loading: false },
        filters: { name: "", status: [{ name: "active", enabled: true }] }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([getRecipientsData[0]]);
    });

    test("filters recipients by name", () => {
      const state = {
        recipientList: { data: getRecipientsData, loading: false },
        filters: { name: "army", status: [{ name: "active", enabled: false }] }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([getRecipientsData[1]]);
    });

    test("filters recipients by status and name", () => {
      const state = {
        recipientList: { data: getRecipientsData, loading: false },
        filters: {
          name: "Welling",
          status: [{ name: "active", enabled: true }]
        }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([getRecipientsData[0]]);
    });

    test("does not filter recipients if no filters are set", () => {
      const state = {
        recipientList: { data: getRecipientsData, loading: false },
        filters: { name: "", status: [{ name: "active", enabled: false }] }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual(getRecipientsData);
    });

    test("returns empty array for no match", () => {
      const state = {
        recipientList: { data: getRecipientsData, loading: false },
        filters: { name: "xxx", status: [{ name: "pending", enabled: true }] }
      };
      const filteredRecipients = getters.filteredRecipients(state);
      expect(filteredRecipients).toEqual([]);
    });
  });
});
