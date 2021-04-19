<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm @submit="createRecipient" />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import RecipientForm from "@/components/recipient/RecipientForm.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IRecipient } from "@/types";
import toast from "@/helpers/toast";

export default defineComponent({
  components: {
    RecipientForm
  },
  methods: {
    async createRecipient(params: IRecipient) {
      await ActiveRecipient.createRecipient(params);

      if (ActiveRecipient.details.id) {
        this.$router.push(`/recipients/${ActiveRecipient.details.id}`);
        toast.success("Recipient created.");
      }
    },

    beforeRouteEnter(_to: any, _from: any, next: any) {
      ActiveRecipient.resetActiveRecipient();
      next();
    }
  }
});
</script>
