import Store from "@/store";
import { IRecipient } from "@/types";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import RecipientService from "@/services/recipient-service";

const defaultRecipientDetails = {
  name: "",
  baseId: "0",
  primaryContact: {
    name: "",
    email: "",
    phoneLandline: "",
    phoneMobile: ""
  }
};

@Module({ name: "activeRecipient", store: Store, dynamic: true })
class ActiveRecipient extends VuexModule {
  details: IRecipient = defaultRecipientDetails;
  status = "";
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
      this.context.commit("setRecipientDetails", recipient);
      this.context.commit("setRecipientStatus", recipient.status);
    } catch (e) {
      this.context.commit("setRecipientErrors", e);
    }
  }

  @Action
  async fetchRecipientStatus(id: string) {
    const recipient = await RecipientService.get(id);
    this.context.commit("setRecipientStatus", recipient.status);
  }

  @Mutation
  setRecipientStatus(status: string) {
    this.status = status;
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
      this.context.commit("setRecipientErrors", errors);
      this.context.commit("setRecipientDetails", details);
    }
  }

  @Action
  async updateRecipient({ recipient }: any) {
    const updatedRecipient = await RecipientService.update(recipient.id, recipient);
    this.context.commit("setRecipientDetails", updatedRecipient);
  }

  @Action
  async archiveRecipient(recipientId: string) {
    const updatedRecipient = await RecipientService.destroy(recipientId);
    this.context.commit("setRecipientDetails", updatedRecipient);
  }
}

export const ActiveRecipientModule = getModule(ActiveRecipient);
