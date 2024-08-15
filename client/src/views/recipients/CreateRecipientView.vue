<script setup lang="ts">
import NewRecipientForm, {
  type NewRecipientDetails,
} from "@/components/recipient/NewRecipientForm.vue"

async function onSubmit(recipient: NewRecipientDetails) {
  console.log("submitted", recipient)
}
</script>

<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <NewRecipientForm :on-submit="onSubmit" />
    </div>
  </div>
</template>
