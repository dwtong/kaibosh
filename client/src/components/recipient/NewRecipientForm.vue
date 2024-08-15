<script setup lang="ts">
import { computed, ref } from "vue"
import { useForm } from "vee-validate"
import { object, string, date } from "zod"
import { toTypedSchema } from "@vee-validate/zod"
import SubmitButton from "../ui/SubmitButton.vue"
import ValidatedInput from "../ui/ValidatedInput.vue"
import ValidatedBaseSelect from "../ui/ValidatedBaseSelect.vue"
import ValidatedDate from "../ui/ValidatedDate.vue"

export type NewRecipientDetails = {
  name: string
  baseId: string
  description?: string
}

const props = defineProps<{
  onSubmit: (recipient: NewRecipientDetails) => Promise<void>
}>()

const validationSchema = toTypedSchema(
  object({
    name: string().nonempty("Name is required"),
    baseId: string().nonempty("Base is required"),
    description: string().optional(),
    date: date().optional(),
  }),
)
const { handleSubmit, submitCount } = useForm({
  validationSchema,
})
const showErrors = computed(() => submitCount.value > 0)
const isSubmitting = ref(false)
const submit = handleSubmit(async (recipient) => {
  isSubmitting.value = true
  await props.onSubmit(recipient)
  isSubmitting.value = false
})
</script>

<template>
  <div class="box">
    <h1 class="title">Organisation Details</h1>
    <form
      class="form"
      :validation-schema="validationSchema"
      @submit.prevent="submit"
    >
      <ValidatedInput name="name" type="text" :show-error="showErrors" />
      <ValidatedBaseSelect
        name="baseId"
        label="kaibosh base"
        placeholder="Select a base..."
        :show-error="showErrors"
      />
      <ValidatedInput name="address" type="text" :show-error="showErrors" />
      <ValidatedDate
        name="date"
        label="start date"
        :show-error="showErrors"
        placeholder="Click to select..."
      />
      <ValidatedInput
        name="description"
        type="textarea"
        :show-error="showErrors"
      />
      <SubmitButton :is-submitting="isSubmitting" />
    </form>

    <!-- <AddressField v-model="recipientDetails.physicalAddress" label="Physical address" /> -->
    <!-- <ValidatedDate v-model="recipientDetails.startedAt" label="start date" /> -->
    <!-- <ValidatedInput v-model="recipientDetails.description" label="description" type="textarea" /> -->
  </div>

  <div class="box">
    <h1 class="title">Primary Contact Details</h1>

    <!-- <ValidatedInput v-model="recipientDetails.contact.name" label="contact name" /> -->
    <!-- <ValidatedInput v-model="recipientDetails.contact.email" label="contact email" :rules="{ email: true }" /> -->
    <!-- <ValidatedInput v-model="recipientDetails.contact.phoneLandline" label="contact landline" /> -->
    <!-- <ValidatedInput v-model="recipientDetails.contact.phoneMobile" label="contact mobile" /> -->
  </div>
</template>
