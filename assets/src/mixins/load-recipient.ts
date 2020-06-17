import { Route } from "vue-router/types/router";
import App from "@/store/modules/app";
import ActiveRecipient from "@/store/modules/active-recipient";

export default {
  async beforeRouteEnter(to: Route, from: Route, next: any) {
    const id = to.params.id;

    if (ActiveRecipient.details?.id?.toString() !== id) {
      App.enableLoading();
      await ActiveRecipient.fetchRecipient(id);
      App.disableLoading();
    }

    next();
  }
};
