<script setup lang="ts">
import RecipientMessageBox from "@/components/recipient/RecipientMessageBox.vue"
import RecipientContactDetails from "@/components/recipient/RecipientContactDetails.vue"
import RecipientOnboardingChecks from "@/components/recipient/RecipientOnboardingChecks.vue"
import RecipientOrganisationDetails from "@/components/recipient/RecipientOrganisationDetails.vue"
import { useAppStore } from "@/stores/app"
import { useRecipientsStore } from "@/stores/recipients"
import { toast } from "@/utils/toast"
import { storeToRefs } from "pinia"
import { onBeforeMount } from "vue"
import { useRoute } from "vue-router"
import RecipientSessions from "@/components/recipient/RecipientSessions.vue"
import { useRecipientSessionsStore } from "@/stores/recipient-sessions"
import { useSessionsStore } from "@/stores/sessions"

const route = useRoute()
const appStore = useAppStore()
const recipientStore = useRecipientsStore()
const sessionsStore = useSessionsStore()
const { recipient, recipientStatus } = storeToRefs(recipientStore)
const { fetchRecipientSessions } = useRecipientSessionsStore()
const recipientId = route.params.id as string

onBeforeMount(async () => {
  appStore.setIsLoading(true)
  await Promise.all([
    appStore.fetchCategories(),
    recipientStore.fetchRecipient(recipientId),
    fetchRecipientSessions(recipientId),
  ])
  if (recipient.value?.baseId) {
    await sessionsStore.fetchSessionsForBase(recipient.value?.baseId)
  }
  appStore.setIsLoading(false)
})

async function archiveRecipient() {
  try {
    await recipientStore.archiveRecipient(recipientId)
    toast({ message: "Recipient archived.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to archive recipient.", type: "is-danger" })
  }
}

async function reactivateRecipient() {
  try {
    await recipientStore.updateRecipient(recipientId, { archivedAt: null })
    toast({ message: "Recipient reactivated.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to reactivate recipient.", type: "is-danger" })
  }
}

async function toggleCheckbox(name: string, value: boolean) {
  try {
    await recipientStore.updateRecipient(recipientId, { [name]: value })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to update recipient.", type: "is-danger" })
  }
}
</script>

<template>
  <div v-if="!appStore.isLoading">
    <div class="title-box">
      <h1 class="title is-inline-block">
        {{ recipient?.name }}
      </h1>

      <div
        v-if="recipientStatus !== 'archived'"
        class="field buttons is-pulled-right"
      >
        <p class="control">
          <router-link
            :to="`/recipients/update/${recipient?.id}`"
            class="button is-info"
          >
            Edit Recipient
          </router-link>
        </p>
        <p class="control">
          <a class="button is-danger" @click="archiveRecipient">
            Archive Recipient
          </a>
        </p>
      </div>
    </div>

    <div class="columns">
      <div class="column">
        <RecipientMessageBox
          :name="recipient?.name"
          :status="recipientStatus"
          :reactivate="reactivateRecipient"
        />
      </div>
    </div>

    <div v-if="recipientStatus !== 'archived'" class="columns">
      <div class="column is-half">
        <RecipientOrganisationDetails :recipient="recipient" />
        <RecipientOnboardingChecks
          :recipient="recipient"
          @input="toggleCheckbox"
        />
      </div>

      <div class="column">
        <RecipientContactDetails :contact="recipient?.contact" />
        <RecipientSessions
          :is-loading="appStore.isLoading"
          :recipient-id="recipientId"
        />
      </div>
    </div>
  </div>
</template>
