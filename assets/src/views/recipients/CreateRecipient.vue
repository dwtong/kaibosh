<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm @submit="createRecipient" />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import RecipientForm from "@/components/recipient/RecipientForm.vue";
import ActiveRecipient from "@/store/modules/active-recipient";
import { IRecipient } from "@/types";
import toast from "@/helpers/toast";
import { Route } from "vue-router/types/router";

@Component({ components: { RecipientForm } })
export default class CreateRecipient extends Vue {
  async createRecipient(params: IRecipient) {
    await ActiveRecipient.createRecipient(params);

    if (ActiveRecipient.details.id) {
      this.$router.push(`/recipients/${ActiveRecipient.details.id}`);
      toast.success("Recipient created.");
    }
  }

  async beforeRouteEnter(to: Route, from: Route, next: any) {
    await ActiveRecipient.resetActiveRecipient();
    next();
  }
}
</script>
