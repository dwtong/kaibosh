import { Route } from "vue-router/types/router";
import Bases from "@/store/modules/bases";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";

export default {
  async beforeRouteEnter(to: Route, from: Route, next: any) {
    const id = to.params.id;

    if (ActiveRecipientModule.details?.id?.toString() !== id) {
      Bases.toggleLoading();
      await ActiveRecipientModule.fetchRecipient(id);
      Bases.toggleLoading();
    }

    next();
  }
};
