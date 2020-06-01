<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <router-link to="/recipients/new" tag="button" class="button is-primary is-pulled-right"
        >Add New Recipient</router-link
      >
    </div>

    <div class="columns">
      <div class="column">
        <div class="box">
          <RecipientsList />
        </div>
      </div>

      <div class="column is-one-quarter">
        <div class="box">
          <RecipientsListFilter />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import RecipientsList from "@/components/recipients/RecipientsList.vue";
import RecipientsListFilter from "@/components/recipients/RecipientsListFilter.vue";

@Component({ components: { RecipientsList, RecipientsListFilter } })
export default class ListRecipients extends Vue {}
</script>
