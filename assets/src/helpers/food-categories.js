import { sortBy } from "lodash";

export const findExistingAllocation = (selectedSession, foodCategory) => {
  if (selectedSession && selectedSession.allocations) {
    return selectedSession.allocations.find(
      s => s.food_category_id == foodCategory.id
    );
  } else {
    return null;
  }
};

export const mapEnabledFoodCategories = (selectedSession, foodCategories) => {
  const categories = foodCategories
    .map(fc => {
      const allocation = findExistingAllocation(selectedSession, fc);

      if (allocation) {
        return {
          id: allocation.id,
          enabled: true,
          quantity: allocation.quantity,
          quantity_label: allocation.quantity_label,
          food_category_id: fc.id,
          name: fc.name
        };
      } else {
        return {
          id: null,
          enabled: false,
          quantity: 0,
          quantity_label: "",
          food_category_id: fc.id,
          name: fc.name
        };
      }
    })
    .sort();

  return sortBy(categories, ["name"]);
};
