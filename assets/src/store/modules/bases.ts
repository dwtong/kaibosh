import { IBase, IFoodCategory, ISessionSlot } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import { sortBy } from "lodash";
import BaseService from "@/services/base-service";
import FoodCategoryService from "@/services/food-category-service";
import SessionSlotService from "@/services/session-slot-service";

@Module({ name: "bases", store: Store, dynamic: true })
class Bases extends VuexModule {
  errors: string[] = [];
  loading = false;
  list: IBase[] = [];
  foodCategories: IFoodCategory[] = [];
  sessionSlots: ISessionSlot[] = [];

  get sessionSlotById() {
    return (id: string) => {
      const slot = this.sessionSlots.find(s => s.id === id);
      return slot ? `${slot.day} ${slot.time}` : "";
    };
  }

  get baseNameById() {
    return (id: string) => {
      const base = this.list.find(b => b.id === id);
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
  async fetchFoodCategories(baseId: string) {
    if (this.foodCategories.length === 0) {
      const categories = await FoodCategoryService.get(baseId);
      this.context.commit("setFoodCategories", categories);
    }
  }

  @Mutation
  setBases(bases: IBase[]) {
    this.list = bases;
  }

  @Action
  async fetchBases() {
    if (this.list.length === 0) {
      const bases: IBase[] = await BaseService.get();
      this.context.commit("setBases", bases);
    }
  }

  @Mutation
  setSessionSlots(slots: ISessionSlot[]) {
    this.sessionSlots = slots;
  }

  @Action
  async fetchSessionSlots(baseId: string) {
    const bases = await SessionSlotService.getForBase(baseId);
    this.context.commit("setSessionSlots", bases);
  }
}

export default getModule(Bases);
