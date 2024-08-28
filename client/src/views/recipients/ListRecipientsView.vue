<script setup lang="ts">
import RecipientsList from "@/components/recipients/RecipientsList.vue"
import RecipientsFilterPanel from "@/components/recipients/RecipientsFilterPanel.vue"
import { useRecipientsStore } from "@/stores/recipients"

const recipientStore = useRecipientsStore()
recipientStore.fetchRecipients()
</script>

<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <RouterLink
        to="/recipients/new"
        class="button is-primary is-pulled-right"
      >
        Add New Recipient
      </RouterLink>
    </div>

    <div class="columns">
      <div class="column">
        <div class="box">
          <RecipientsList :recipients="recipientStore.recipients" />
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
