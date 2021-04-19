import App from "@/store/modules/app";
import ActiveRecipient from "@/store/modules/active-recipient";

export default {
  async beforeRouteEnter(to: any, _from: any, next: any) {
    const id = to.params.id;

    if (ActiveRecipient.details?.id?.toString() !== id) {
      App.enableLoading();
      await ActiveRecipient.fetchRecipient(id);
      App.disableLoading();
    }

    next();
  }
};
