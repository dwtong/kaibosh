import Vue from "vue";
import Store from "@/store";
import { IRecipient, IHold, IScheduledSession } from "@/types";
import {
  Action,
  getModule,
  Module,
  Mutation,
  VuexModule
} from "vuex-module-decorators";
import RecipientService from "@/services/recipient-service";
import HoldService from "@/services/session-hold-service";
import ScheduledSessionService from "@/services/scheduled-session-service";

const defaultRecipientDetails = {
  name: "",
  base_id: "0",
  primary_contact: {
    name: "",
    email: "",
    phone_landline: "",
    phone_mobile: ""
  }
};

@Module({ name: "activeRecipient", store: Store, dynamic: true })
class ActiveRecipient extends VuexModule {
  details: IRecipient = defaultRecipientDetails;
  scheduledSessions: IScheduledSession[] = [];

  errors: any = null;

  @Mutation
  setRecipientDetails(recipient: IRecipient) {
    this.details = recipient;
  }

  @Mutation
  setRecipientErrors(errors: any) {
    this.errors = JSON.stringify(errors);
  }

  @Action
  resetActiveRecipient() {
    this.context.commit("setRecipientDetails", defaultRecipientDetails);
  }

  @Action
  async fetchRecipient(id: string) {
    try {
      const recipient = await RecipientService.get(id);
      const scheduledSessions = await ScheduledSessionService.get(id);
      this.context.commit("setRecipientDetails", recipient);
      this.context.dispatch("fetchRecipientSessions", id);
    } catch (e) {
      this.context.commit("setRecipientErrors", e);
    }
  }

  @Mutation
  setScheduledSessions(scheduledSessions: []) {
    this.scheduledSessions = scheduledSessions;
  }

  @Action
  async fetchRecipientSessions(id: string) {
    if (id) {
      try {
        const scheduledSessions = await ScheduledSessionService.get(id);
        this.context.commit("setScheduledSessions", scheduledSessions);
      } catch (e) {
        this.context.commit("setRecipientErrors", e);
      }
    }
  }

  @Action
  async createRecipient(recipient: any) {
    let errors = null;
    let details = defaultRecipientDetails;

    try {
      const createdRecipient = await RecipientService.create(recipient);
      details = createdRecipient;
    } catch (e) {
      errors = e;
      details = defaultRecipientDetails;
    } finally {
      await this.context.commit("setRecipientErrors", errors);
      await this.context.commit("setRecipientDetails", details);
    }
  }

  @Action
  async updateRecipient(recipient: any) {
    const updatedRecipient = await RecipientService.update(
      recipient.id,
      recipient
    );
    await this.context.commit("setRecipientDetails", updatedRecipient);
  }

  @Action
  async archiveRecipient(recipientId: string) {
    const updatedRecipient = await RecipientService.destroy(recipientId);
    await this.context.commit("setRecipientDetails", updatedRecipient);
  }

  @Action
  async createHolds(holds: IHold[]) {
    await holds.forEach(hold => HoldService.create(hold));
    // TODO: Mutate holds instead of refreshing all sessions
    this.context.dispatch("fetchRecipientSessions", this.details.id);
  }

  @Action
  async deleteHold(hold: IHold) {
    await HoldService.destroy(hold.id!);
    // TODO: Mutate holds instead of refreshing all sessions
    this.context.dispatch("fetchRecipientSessions", this.details.id);
  }

  @Action
  async createScheduledSession(session: IScheduledSession) {
    await ScheduledSessionService.create({ session });
    // TODO: Mutate sessions instead of refreshing all sessions
    this.context.dispatch("fetchRecipientSessions", this.details.id);
  }

  @Action
  async updateScheduledSession(session: IScheduledSession) {
    await ScheduledSessionService.update(session.id!, { session });
    // TODO: Mutate sessions instead of refreshing all sessions
    this.context.dispatch("fetchRecipientSessions", this.details.id);
  }

  @Action
  async deleteScheduledSession(sessionId: string) {
    await ScheduledSessionService.destroy(sessionId);
    // TODO: Mutate sessions instead of refreshing all sessions
    this.context.dispatch("fetchRecipientSessions", this.details.id);
  }
}

export const ActiveRecipientModule = getModule(ActiveRecipient);
