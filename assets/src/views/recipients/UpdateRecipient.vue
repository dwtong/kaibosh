<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm v-if="recipient" @submit="updateRecipient" :recipient="recipient" />
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
export default class UpdateRecipient extends Vue {
  @Prop(String) readonly id!: string;
  recipient: IRecipient | null = null;

  async created() {
    await ActiveRecipientModule.fetchRecipient(this.id);
    this.recipient = ActiveRecipientModule.details;
  }

  async updateRecipient(params: IRecipient) {
    await ActiveRecipientModule.updateRecipient(params);
    this.$router.push(`/recipients/${params.id}`);
    toast.success("Recipient updated.");
  }
}
</script>
