import { sortBy } from "lodash";
import { ISession } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import AllocationService from "@/services/allocation-service";
import SessionService from "@/services/session-slot-service";
import { dayIndexFromString } from "@/helpers/date";

@Module({ name: "Sessions", store: Store, dynamic: true })
class Sessions extends VuexModule {
  allocationsByCategory: any = [];
  list: ISession[] = [];
  details: ISession = {
    id: "",
    time: "",
    day: "",
    date: "",
    recipients: []
  };
  date: any = "";

  get sessionsForDay() {
    return (day: string) =>
      sortBy(
        this.list.filter(s => s.day === day),
        "time"
      );
  }

  get sortedList() {
    return sortBy(this.list, (s: any) => `${dayIndexFromString(s.day)}-${s.time}`);
  }

  @Mutation
  setList(slots: ISession[]) {
    this.list = slots;
  }

  @Action
  async fetchList(baseId: string) {
    const list = await SessionService.getForBase(baseId);
    this.context.commit("setList", list);
  }

  get orderedRecipients() {
    return sortBy(this.details.recipients, ["name"]);
  }

  // TODO: fetch session slot
  // @Action
  // async fetchSession(sessionId: string) {
  // const slot = await SessionService.get(sessionId);
  // this.context.commit("setSession", slot);
  // }

  @Action
  async fetchAllocationsForSlot({ sessionId, sessionDate }: { sessionId: string; sessionDate: string }) {
    const { categoryAllocations, date } = await AllocationService.getForSession(sessionId, sessionDate);
    this.context.commit("setDate", date);
    this.context.commit("setAllocations", categoryAllocations);
  }

  @Mutation
  setSession(session: ISession) {
    this.details = session;
  }

  @Mutation
  setAllocations(allocations: any) {
    this.allocationsByCategory = allocations;
  }

  @Mutation
  setDate(date: string) {
    this.date = new Date(date);
  }
}

export default getModule(Sessions);
