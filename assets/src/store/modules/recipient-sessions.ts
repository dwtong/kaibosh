import Vue from "vue";
import Store from "@/store";
import { IHold, IScheduledSession } from "@/types";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import HoldService from "@/services/session-hold-service";
import ScheduledSessionService from "@/services/scheduled-session-service";

@Module({ name: "recipientSessions", store: Store, dynamic: true })
class RecipientSessions extends VuexModule {
  sessions: IScheduledSession[] = [];
  errors = null;

  get sessionById() {
    return (id: string) => {
      return this.sessions.find(s => s.id === id);
    };
  }

  @Action
  async fetchSessions(recipientId: string) {
    try {
      const sessions = await ScheduledSessionService.getForRecipient(recipientId);
      this.context.commit("setSessions", sessions);
    } catch (e) {
      this.context.commit("setErrors", e);
    }
  }

  @Mutation
  setSessions(sessions: []) {
    Vue.set(this, "sessions", sessions);
  }

  @Mutation
  addSession(session: IScheduledSession) {
    this.sessions.push(session);
  }

  @Mutation
  modifySession(updatedSession: IScheduledSession, sessionId: string) {
    const sessionIndex = this.sessions.findIndex((s: IScheduledSession) => s.id === sessionId);
    Vue.set(this.sessions, sessionIndex, updatedSession);
  }

  @Action
  async createHolds(holds: IHold[]) {
    for (const hold of holds) {
      await HoldService.create(hold);
    }

    const session = this.sessionById(holds[0].sessionId);

    if (session && session.recipientId) {
      ActiveRecipientModule.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }

  @Action
  async deleteHold(hold: IHold) {
    if (hold.id) {
      await HoldService.destroy(hold.id);
      const session = this.sessionById(hold.sessionId);

      if (session?.recipientId) {
        ActiveRecipientModule.fetchRecipientStatus(session.recipientId);
        this.fetchSessions(session.recipientId);
      }
    }
  }

  @Action
  async createSession(session: IScheduledSession) {
    await ScheduledSessionService.create({ session });

    if (session?.recipientId) {
      ActiveRecipientModule.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }

  @Action
  async updateSession(session: IScheduledSession) {
    if (session.id) {
      await ScheduledSessionService.update(session.id, { session });

      if (session.recipientId) {
        ActiveRecipientModule.fetchRecipientStatus(session.recipientId);
        this.fetchSessions(session.recipientId);
      }
    }
  }

  @Action
  async deleteSession(sessionId: string) {
    await ScheduledSessionService.destroy(sessionId);
    const session = this.sessionById(sessionId);

    if (session?.recipientId) {
      ActiveRecipientModule.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }
}

export default getModule(RecipientSessions);
