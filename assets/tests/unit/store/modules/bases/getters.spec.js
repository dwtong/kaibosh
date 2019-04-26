import getters from "@/store/modules/bases/getters";
const foodCategories = [
  { id: 1, name: "fruit" },
  { id: 2, name: "dairy" },
  { id: 3, name: "meat" }
];

describe("getters", () => {
  describe("foodCategoryById", () => {
    test("returns food category for id", () => {
      const state = { foodCategories };
      const foodCategory = getters.foodCategoryById(state)(2);
      expect(foodCategory).toEqual(foodCategories[1]);
    });
  });
});
