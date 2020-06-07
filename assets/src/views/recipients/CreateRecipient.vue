<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm @submit="createRecipient" />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientForm from "@/components/recipient/RecipientForm.vue";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import { IRecipient } from "@/types";
import toast from "@/helpers/toast";

@Component({ components: { RecipientForm } })
export default class CreateRecipient extends Vue {
  @Prop(String) readonly recipientId!: string;

  recipient!: IRecipient;

  async created() {
    await ActiveRecipientModule.fetchRecipient(this.recipientId);
    this.recipient = ActiveRecipientModule.details;
  }

  async createRecipient(params: IRecipient) {
    await ActiveRecipientModule.createRecipient(params);

    if (ActiveRecipientModule.details.id) {
      this.$router.push(`/recipients/${ActiveRecipientModule.details.id}`);
      toast.success("Recipient created.");
    }
  }
}
</script>
