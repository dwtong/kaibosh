<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <router-link to="/recipients/new" tag="button" class="button is-primary is-pulled-right">
        Add New Recipient
      </router-link>
    </div>

    <div class="columns">
      <div class="column">
        <div class="box">
          <RecipientsList :recipients="recipientsList" :loading="loading" />
        </div>
      </div>

      <div class="column is-one-quarter">
        <div class="box">
          <RecipientsFilterPanel />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import RecipientsList from "@/components/recipients/RecipientsList.vue";
import RecipientsFilterPanel from "@/components/recipients/RecipientsFilterPanel.vue";
import AllRecipients from "@/store/modules/all-recipients";

@Component({ components: { RecipientsList, RecipientsFilterPanel } })
export default class ListRecipients extends Vue {
  loading = AllRecipients.filteredList.length === 0;

  async created() {
    await AllRecipients.fetchRecipients();
    this.loading = false;
  }

  get recipientsList() {
    return AllRecipients.filteredList;
  }
}
</script>
