import Store from "@/store";
import {
  Action,
  getModule,
  Module,
  Mutation,
  VuexModule
} from "vuex-module-decorators";
import AllocationService from "@/services/allocation-service";

@Module({ name: "sessionSlots", store: Store, dynamic: true })
class SessionSlots extends VuexModule {
  allocationsByFoodCategory: any = [];

  @Action
  async fetchAllocationsForSlot(sessionSlotId: string) {
    const allocations = await AllocationService.getForSessionSlot(sessionSlotId);
    this.context.commit("setAllocations", allocations);
  }

  @Mutation
  setAllocations(allocations: any) {
    this.allocationsByFoodCategory = allocations;
  }
}

export const SessionSlotsModule = getModule(SessionSlots);
