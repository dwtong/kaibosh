<script setup lang="ts">
import { createRecipient, type Recipient } from "@/api/recipients"
import RecipientForm from "@/components/recipient/RecipientForm.vue"
import { useRouter } from "vue-router"
import { toast } from "@/utils/toast"
const router = useRouter()

async function onSubmit(recipient: Partial<Recipient>) {
  try {
    const { id } = await createRecipient(recipient)
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
      <RecipientForm :on-submit="onSubmit" />
    </div>
  </div>
</template>
