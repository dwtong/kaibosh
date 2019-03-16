import getters from "@/store/modules/recipients/getters";
const recipientList = [
  { id: 1, name: "Wellington Food Bank", status: "active" },
  { id: 2, name: "Salvation Army Lower Hutt", status: "archived" }
];

describe("getters", () => {
  describe("filteredRecipientList", () => {
    test("filters recipients by status", () => {
      const state = {
        recipientList,
        filters: { name: "", status: [{ name: "active", enabled: true }] }
      };
      const filteredRecipients = getters.filteredRecipientList(state);
      expect(filteredRecipients).toEqual([recipientList[0]]);
    });

    test("filters recipients by name", () => {
      const state = {
        recipientList,
        filters: { name: "army", status: [{ name: "active", enabled: false }] }
      };
      const filteredRecipients = getters.filteredRecipientList(state);
      expect(filteredRecipients).toEqual([recipientList[1]]);
    });

    test("filters recipients by status and name", () => {
      const state = {
        recipientList,
        filters: {
          name: "Welling",
          status: [{ name: "active", enabled: true }]
        }
      };
      const filteredRecipients = getters.filteredRecipientList(state);
      expect(filteredRecipients).toEqual([recipientList[0]]);
    });

    test("does not filter recipients if no filters are set", () => {
      const state = {
        recipientList,
        filters: { name: "", status: [{ name: "active", enabled: false }] }
      };
      const filteredRecipients = getters.filteredRecipientList(state);
      expect(filteredRecipients).toEqual(recipientList);
    });

    test("returns empty array for no match", () => {
      const state = {
        recipientList,
        filters: { name: "xxx", status: [{ name: "pending", enabled: true }] }
      };
      const filteredRecipients = getters.filteredRecipientList(state);
      expect(filteredRecipients).toEqual([]);
    });
  });
});
