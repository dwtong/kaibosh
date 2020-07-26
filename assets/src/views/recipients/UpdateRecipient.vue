<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm v-if="recipient" :recipient="recipient" @submit="updateRecipient" />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientForm from "@/components/recipient/RecipientForm.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IRecipient } from "@/types";
import toast from "@/helpers/toast";
import LoadRecipient from "@/mixins/load-recipient";

@Component({ components: { RecipientForm }, mixins: [LoadRecipient] })
export default class UpdateRecipient extends Vue {
  @Prop(String) readonly id!: string;
  recipient: IRecipient | null = null;

  async created() {
    this.recipient = ActiveRecipient.details;
  }

  async updateRecipient(params: IRecipient) {
    await ActiveRecipient.updateRecipient(params);
    this.$router.push(`/recipients/${params.id}`);
    toast.success("Recipient updated.");
  }
}
</script>
