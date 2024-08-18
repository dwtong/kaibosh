<script setup lang="ts">
import { createRecipient, type NewRecipient } from "@/api/recipients"
import NewRecipientForm, {
  type NewRecipientDetails,
} from "@/components/recipient/NewRecipientForm.vue"
import { useRouter } from "vue-router"
import { toast } from "@/utils/toast"
const router = useRouter()

async function onSubmit(recipient: NewRecipientDetails) {
  const {
    baseId,
    contactName,
    contactEmail,
    contactPhoneMobile,
    contactPhoneLandline,
    ...recipientDetails
  } = recipient
  const recipientParams: NewRecipient = {
    baseId: parseInt(baseId),
    contact: {
      name: contactName || "",
      email: contactEmail || "",
      phoneMobile: contactPhoneMobile || "",
      phoneLandline: contactPhoneLandline || "",
    },
    ...recipientDetails,
  }
  try {
    const { id } = await createRecipient(recipientParams)
    router.push(`/recipients/${id}`)
    toast({ message: "Recipient created.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to create recipient.", type: "is-danger" })
  }
}
</script>

<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <NewRecipientForm :on-submit="onSubmit" />
    </div>
  </div>
</template>
