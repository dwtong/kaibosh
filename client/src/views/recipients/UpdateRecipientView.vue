<script setup lang="ts">
import { putRecipient, type Recipient } from "@/api/recipients"
import RecipientForm from "@/components/recipient/RecipientForm.vue"
import { useRouter } from "vue-router"
import { toast } from "@/utils/toast"
import { useRecipientsStore } from "@/stores/recipients"
import { storeToRefs } from "pinia"
const router = useRouter()
const recipientStore = useRecipientsStore()
const { recipient } = storeToRefs(recipientStore)

async function onSubmit(recipientParams: Partial<Recipient>) {
  const recipientId = recipient.value?.id as string
  try {
    await putRecipient(recipientId, recipientParams)
    router.push(`/recipients/${recipientId}`)
    toast({ message: "Recipient updated.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to update recipient.", type: "is-danger" })
  }
}
</script>

<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <RecipientForm :recipient="recipient" :on-submit="onSubmit" />
    </div>
  </div>
</template>
