import { sortBy } from "lodash";
import { ISession } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import SessionService from "@/services/session-service";
import { dayIndexFromString } from "@/helpers/date";

@Module({ name: "sessions", store: Store, dynamic: true })
class Sessions extends VuexModule {
  sessionList: ISession[] = [];

  get sortedList() {
    return sortBy(this.sessionList, (s: any) => `${dayIndexFromString(s.day)}-${s.time}`);
  }

  @Mutation
  setList(sessions: ISession[]) {
    this.sessionList = sessions;
  }

  @Action
  async fetchList(baseId: string) {
    const sessionList = await SessionService.getForBase(baseId);
    this.context.commit("setList", sessionList);
  }
}

export default getModule(Sessions);
