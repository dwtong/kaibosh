import Vue from "vue";
import Store from "@/store";
import { IHold, IRecipientSession } from "@/types";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import ActiveRecipient from "@/store/modules/active-recipient";
import HoldService from "@/services/session-hold-service";
import RecipientSessionService from "@/services/recipient-session-service";

@Module({ name: "recipientSessions", store: Store, dynamic: true })
class RecipientSessions extends VuexModule {
  sessions: IRecipientSession[] = [];
  errors = null;

  get sessionById() {
    return (id: string) => {
      return this.sessions.find(s => s.id === id);
    };
  }

  @Action
  async fetchSessions(recipientId: string) {
    try {
      const sessions = await RecipientSessionService.getForRecipient(recipientId);
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
  addSession(session: IRecipientSession) {
    this.sessions.push(session);
  }

  @Mutation
  modifySession(updatedSession: IRecipientSession, sessionId: string) {
    const sessionIndex = this.sessions.findIndex((s: IRecipientSession) => s.id === sessionId);
    Vue.set(this.sessions, sessionIndex, updatedSession);
  }

  @Action
  async createHolds(holds: IHold[]) {
    for (const hold of holds) {
      await HoldService.create(hold);
    }

    const session = this.sessionById(holds[0].sessionId);

    if (session && session.recipientId) {
      ActiveRecipient.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }

  @Action
  async deleteHold(holdId: string, sessionId: string) {
    await HoldService.destroy(holdId);
    const session = this.sessionById(sessionId);

    if (session?.recipientId) {
      ActiveRecipient.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }

  @Action
  async createSession(session: IRecipientSession) {
    await RecipientSessionService.create(session.recipientId, { session });

    if (session?.recipientId) {
      ActiveRecipient.fetchRecipientStatus(session.recipientId);
      this.fetchSessions(session.recipientId);
    }
  }

  @Action
  async updateSession(session: IRecipientSession) {
    if (session.id) {
      await RecipientSessionService.update(session.recipientId, session.id, { session });

      if (session.recipientId) {
        ActiveRecipient.fetchRecipientStatus(session.recipientId);
        this.fetchSessions(session.recipientId);
      }
    }
  }

  @Action
  async deleteSession({ recipientId, sessionId }: { recipientId: string; sessionId: string }) {
    await RecipientSessionService.destroy(recipientId, sessionId);
    ActiveRecipient.fetchRecipientStatus(recipientId);
    this.fetchSessions(sessionId);
  }
}

export default getModule(RecipientSessions);
