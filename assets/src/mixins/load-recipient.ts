import { Route } from "vue-router/types/router";
import App from "@/store/modules/app";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";

export default {
  async beforeRouteEnter(to: Route, from: Route, next: any) {
    const id = to.params.id;

    if (ActiveRecipientModule.details?.id?.toString() !== id) {
      App.enableLoading();
      await ActiveRecipientModule.fetchRecipient(id);
      App.disableLoading();
    }

    next();
  }
};
