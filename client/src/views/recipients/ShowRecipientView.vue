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

const route = useRoute()
const appStore = useAppStore()
const recipientStore = useRecipientsStore()
const { recipient, recipientStatus } = storeToRefs(recipientStore)

onBeforeMount(async () => {
  appStore.setIsLoading(true)
  await recipientStore.fetchRecipient(route.params.id as string)
  appStore.setIsLoading(false)
})

async function archiveRecipient() {
  const recipientId = recipient?.value?.id as string
  try {
    await recipientStore.archiveRecipient(recipientId)
    toast({ message: "Recipient archived.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to archive recipient.", type: "is-danger" })
  }
}

async function reactivateRecipient() {
  const recipientId = recipient?.value?.id as string
  try {
    await recipientStore.updateRecipient(recipientId, { archivedAt: null })
    toast({ message: "Recipient reactivated.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to reactivate recipient.", type: "is-danger" })
  }
}

async function toggleCheckbox(name: string, value: boolean) {
  const recipientId = recipient?.value?.id as string
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
        <RecipientSortingSessions />
      </div>
    </div>
  </div>
</template>
