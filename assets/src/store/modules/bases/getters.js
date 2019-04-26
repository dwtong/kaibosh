export default {
  foodCategoryById(state) {
    return id => state.foodCategories.find(fc => fc.id === id);
  }
};
