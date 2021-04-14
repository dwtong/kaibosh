import { ISessionPlan, ISessionPlanDetails } from "@/types";
import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import SessionPlanService from "@/services/session-plan-service";
import { capitalize, sortBy } from "lodash";

@Module({ name: "sessionPlans", store: Store, dynamic: true })
class SessionPlans extends VuexModule {
  planList: ISessionPlan[] = [];
  planDetails: ISessionPlanDetails = {
    session: {
      date: "",
      day: "",
      time: ""
    },
    allocations: [],
    recipients: []
  };

  get recipientById() {
    return (id: string) => this.planDetails.recipients.find(r => r.id === id);
  }

  get sessionDateTime(): Date {
    return new Date(`${this.planDetails.session.date}T${this.planDetails.session.time}`);
  }

  get orderedRecipients() {
    return sortBy(this.planDetails.recipients, "name");
  }

  get allocationsForCategory() {
    return (categoryId: string) => {
      return this.planDetails.allocations.filter(a => a.categoryId === categoryId);
    };
  }

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

  @Mutation
  setPlanDetails(plan: ISessionPlanDetails) {
    this.planDetails = plan;
  }

  @Action
  async fetchPlanDetails({
    baseId: baseId,
    sessionId: sessionId,
    date: date
  }: {
    baseId: string;
    sessionId: string;
    date: string;
  }) {
    const plan = await SessionPlanService.getForSession(baseId, sessionId, date);
    this.context.commit("setPlanDetails", plan);
  }
}

export default getModule(SessionPlans);
