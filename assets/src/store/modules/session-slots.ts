import { ISessionSlot } from "@/types";
import Store from "@/store";
import {
  Action,
  getModule,
  Module,
  Mutation,
  VuexModule
} from "vuex-module-decorators";
import AllocationService from "@/services/allocation-service";
import SessionSlotService from "@/services/session-slot-service";

@Module({ name: "sessionSlots", store: Store, dynamic: true })
class SessionSlots extends VuexModule {
  allocationsByFoodCategory: any = [];
  details: ISessionSlot = {id: "", time: "", day: ""};

  @Action
  async fetchSessionSlot(sessionSlotId: string) {
    const slot = await SessionSlotService.get(sessionSlotId);
    this.context.commit("setSessionSlot", slot);
  }

  @Action
  async fetchAllocationsForSlot(sessionSlotId: string) {
    const allocations = await AllocationService.getForSessionSlot(sessionSlotId);
    this.context.commit("setAllocations", allocations);
  }

  @Mutation
  setSessionSlot(sessionSlot: ISessionSlot) {
    console.log("doiing it")
    console.log(sessionSlot)
    this.details = sessionSlot;
  }

  @Mutation
  setAllocations(allocations: any) {
    this.allocationsByFoodCategory = allocations;
  }

  get sessionName() {
    if (this.details.day && this.details.time) {
      return `${this.details.day} ${this.details.time}`;
    } else {
      return "";
    }
  }
}

export const SessionSlotsModule = getModule(SessionSlots);
