import { IBase, ICategory } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import { sortBy } from "lodash";
import BaseService from "@/services/base-service";
import CategoryService from "@/services/category-service";

@Module({ name: "app", store: Store, dynamic: true })
class App extends VuexModule {
  errors: string[] = [];
  loading = false;
  bases: IBase[] = [];
  categories: ICategory[] = [];

  get baseNameById() {
    return (id: string) => {
      const base = this.bases.find(b => b.id === id);
      return base ? base.name : "";
    };
  }

  get categoryById() {
    return (id: string) => this.categories.find(fc => fc.id === id);
  }

  get orderedCategories() {
    return sortBy(this.categories, ["name"]);
  }

  @Mutation
  setCategories(categories: ICategory[]) {
    this.categories = categories;
  }

  @Action
  async fetchCategories() {
    if (this.categories.length === 0) {
      const categories = await CategoryService.get();
      this.context.commit("setCategories", categories);
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
