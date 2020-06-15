import { IBase, IFoodCategory } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import { sortBy } from "lodash";
import BaseService from "@/services/base-service";
import FoodCategoryService from "@/services/food-category-service";

@Module({ name: "app", store: Store, dynamic: true })
class App extends VuexModule {
  errors: string[] = [];
  loading = false;
  bases: IBase[] = [];
  foodCategories: IFoodCategory[] = [];

  get baseNameById() {
    return (id: string) => {
      const base = this.bases.find(b => b.id === id);
      return base ? base.name : "";
    };
  }

  get foodCategoryById() {
    return (id: string) => this.foodCategories.find(fc => fc.id === id);
  }

  get orderedFoodCategories() {
    return sortBy(this.foodCategories, ["name"]);
  }

  @Mutation
  setFoodCategories(foodCategories: IFoodCategory[]) {
    this.foodCategories = foodCategories;
  }

  @Action
  async fetchAll() {
    this.context.commit("setLoading", true);
    await Promise.all([this.fetchBases(), this.fetchFoodCategories()]);
    this.context.commit("setLoading", false);
  }

  @Action
  async fetchFoodCategories() {
    if (this.foodCategories.length === 0) {
      const categories = await FoodCategoryService.get();
      this.context.commit("setFoodCategories", categories);
    }
  }

  @Mutation
  setBases(bases: IBase[]) {
    this.bases = bases;
  }

  @Action
  async fetchBases() {
    const bases: IBase[] = await BaseService.get();
    this.context.commit("setBases", bases);
  }

  @Mutation
  setLoading(loading: boolean) {
    this.loading = loading;
  }

  @Action
  async enableLoading() {
    this.context.commit("setLoading", true);
  }

  @Action
  async disableLoading() {
    this.context.commit("setLoading", false);
  }
}

export default getModule(App);
