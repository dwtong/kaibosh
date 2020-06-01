import { sortBy } from "lodash";
import { ISessionSlot } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import AllocationService from "@/services/allocation-service";
import SessionSlotService from "@/services/session-slot-service";

@Module({ name: "sessionSlots", store: Store, dynamic: true })
class SessionSlots extends VuexModule {
  allocationsByFoodCategory: any = [];
  details: ISessionSlot = {
    id: "",
    time: "",
    day: "",
    date: "",
    recipients: []
  };
  date: any = "";

  get orderedRecipients() {
    return sortBy(this.details.recipients, ["name"]);
  }

  @Action
  async fetchSessionSlot(sessionSlotId: string) {
    const slot = await SessionSlotService.get(sessionSlotId);
    this.context.commit("setSessionSlot", slot);
  }

  @Action
  async fetchAllocationsForSlot({ sessionSlotId, sessionDate }: { sessionSlotId: string; sessionDate: string }) {
    const { foodAllocations, date } = await AllocationService.getForSessionSlot(sessionSlotId, sessionDate);
    this.context.commit("setDate", date);
    this.context.commit("setAllocations", foodAllocations);
  }

  @Mutation
  setSessionSlot(sessionSlot: ISessionSlot) {
    this.details = sessionSlot;
  }

  @Mutation
  setAllocations(allocations: any) {
    this.allocationsByFoodCategory = allocations;
  }

  @Mutation
  setDate(date: string) {
    this.date = new Date(date);
  }
}

export const SessionSlotsModule = getModule(SessionSlots);
