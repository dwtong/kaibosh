import { IBase, IFoodCategory, ISessionSlot } from "@/types";
import Store from "@/store";
import {
  Action,
  getModule,
  Module,
  Mutation,
  VuexModule
} from "vuex-module-decorators";
import BaseService from "@/services/base-service";
import FoodCategoryService from "@/services/food-category-service";
import SessionSlotService from "@/services/session-slot-service";

@Module({ name: "bases", store: Store, dynamic: true })
class Bases extends VuexModule {
  errors: string[] = [];
  loading: boolean = false;
  list: IBase[] = [];
  foodCategories: IFoodCategory[] = [];
  sessionSlots: ISessionSlot[] = [];

  get baseNameById() {
    return (id: string) => {
      const base = this.list.find(b => b.id === id);
      return base ? base.name : "";
    };
  }

  get foodCategoryById() {
    return (id: string) => this.foodCategories.find(fc => fc.id === id);
  }

  @Mutation
  setFoodCategories(foodCategories: IFoodCategory[]) {
    this.foodCategories = foodCategories;
  }

  @Action
  async fetchFoodCategories() {
    const categories = await FoodCategoryService.get();
    this.context.commit("setFoodCategories", categories);
  }

  @Mutation
  setBases(bases: IBase[]) {
    this.list = bases;
  }

  @Action
  async fetchBases() {
    const bases = await BaseService.get();
    this.context.commit("setBases", bases);
  }

  @Mutation
  setSessionSlots(slots: ISessionSlot[]) {
    this.sessionSlots = slots;
  }

  @Action
  async fetchSessionSlots(baseId: string) {
    const bases = await SessionSlotService.get(baseId);
    this.context.commit("setSessionSlots", bases);
  }
}

export const BasesModule = getModule(Bases);
