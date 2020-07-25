import { sortBy } from "lodash";
import { ISessionPlan } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import SessionPlanService from "@/services/session-plan-service";
import { capitalize } from "lodash";

@Module({ name: "sessionPlans", store: Store, dynamic: true })
class SessionPlans extends VuexModule {
  planList: ISessionPlan[] = [];

  get plansForDay() {
    return (day: string) =>
      sortBy(
        this.planList.filter(p => capitalize(p.session.day) === day),
        p => p.session.time
      );
  }

  @Mutation
  setPlanList(plans: ISessionPlan[]) {
    this.planList = plans;
  }

  @Action
  async fetchPlanList({ baseId: baseId, weekOfDate: weekOfDate }: { baseId: string; weekOfDate: string }) {
    const planList = await SessionPlanService.getForBase(baseId, weekOfDate);
    this.context.commit("setPlanList", planList);
  }
}

export default getModule(SessionPlans);
