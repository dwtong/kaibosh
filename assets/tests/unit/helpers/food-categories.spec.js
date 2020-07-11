import { mapEnabledFoodCategories } from "@/helpers/food-categories";

const foodCategories = [
  { id: 1, name: "Bread" },
  { id: 2, name: "Sandwiches" },
  { id: 3, name: "Bakery" },
  { id: 4, name: "Produce" },
  { id: 5, name: "Beverages" },
  { id: 6, name: "Ready meals" },
  { id: 7, name: "Dairy" },
  { id: 8, name: "Meat" },
  { id: 9, name: "Other" }
];

const sessionWithoutAllocations = {
  id: 31,
  recipientId: 11,
  sessionSlot: { id: 6, day: "Saturday", time: "11:00AM" },
  allocations: []
};

const sessionWithAllocations = {
  id: 31,
  recipientId: 11,
  sessionSlot: { id: 6, day: "Saturday", time: "11:00AM" },
  allocations: [
    {
      id: 72,
      foodCategoryId: 3,
      quantity: "2.0",
      quantityLabel: "2 boxes"
    },
    {
      id: 73,
      foodCategoryId: 4,
      quantity: "0.0",
      quantityLabel: "no boxes"
    },
    { id: 74, foodCategoryId: 5, quantity: "0.0", quantityLabel: "no boxes" }
  ]
};

describe("mapEnabledFoodCategories", () => {
  it("marks food categories as enabled when session allocation exists", () => {
    const categories = mapEnabledFoodCategories(sessionWithAllocations, foodCategories);

    const expected = sessionWithAllocations.allocations[0];
    const actual = categories.find(c => c.id == sessionWithAllocations.allocations[0].id);

    expect(categories.filter(c => c.enabled).length).toEqual(3);
    expect(actual.id).toEqual(expected.id);
    expect(actual.foodCategoryId).toEqual(expected.foodCategoryId);
    expect(actual.quantity).toEqual(expected.quantity);
    expect(actual.quantityLabel).toEqual(expected.quantityLabel);
    expect(actual.enabled).toEqual(true);
  });

  it("marks food categories as disabled when no session allocation exists", () => {
    const categories = mapEnabledFoodCategories(sessionWithoutAllocations, foodCategories);

    const expected = foodCategories[0];
    const actual = categories.find(c => c.foodCategoryId == expected.id);

    expect(categories.length).toEqual(foodCategories.length);
    expect(actual.id).toEqual(null);
    expect(actual.foodCategoryId).toEqual(expected.id);
    expect(actual.quantity).toEqual(0);
    expect(actual.enabled).toEqual(false);
    expect(actual.quantityLabel).toEqual("");
  });

  it("includes both enabled and disabled categories", () => {
    const categories = mapEnabledFoodCategories(sessionWithAllocations, foodCategories);

    expect(categories.length).toEqual(9);
    expect(categories.filter(c => c.enabled == true).length).toEqual(3);
    expect(categories.filter(c => c.enabled == false).length).toEqual(6);
  });

  it("returns categories in alphabetical order", () => {
    const categories = mapEnabledFoodCategories(sessionWithAllocations, foodCategories);

    expect(categories[0].name).toEqual("Bakery");
    expect(categories[8].name).toEqual("Sandwiches");
  });
});
