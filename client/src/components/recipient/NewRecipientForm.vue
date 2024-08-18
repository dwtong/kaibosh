<script setup lang="ts">
import { computed, ref } from "vue"
import { useForm } from "vee-validate"
import { object, string, date } from "zod"
import { toTypedSchema } from "@vee-validate/zod"
import SubmitButton from "../ui/SubmitButton.vue"
import ValidatedInput from "../ui/ValidatedInput.vue"
import ValidatedBaseSelect from "../ui/ValidatedBaseSelect.vue"
import ValidatedDate from "../ui/ValidatedDate.vue"
import ValidatedAddress from "../ui/ValidatedAddress.vue"

export type NewRecipientDetails = {
  name: string
  baseId: string
  description?: string
  startDate?: Date
  contactName?: string
  contactEmail?: string
  contactPhoneLandline?: string
  contactPhoneMobile?: string
  physicalAddress?: string
}

const props = defineProps<{
  onSubmit: (recipient: NewRecipientDetails) => Promise<void>
}>()

const validationSchema = toTypedSchema(
  object({
    name: string().nonempty("Name is required"),
    baseId: string().nonempty("Base is required"),
    description: string().optional(),
    startDate: date().optional(),
    contactName: string().optional(),
    contactEmail: string().email().optional(),
    contactPhoneLandline: string().optional(),
    contactPhoneMobile: string().optional(),
    physicalAddress: string().optional(),
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
  <form
    class="form"
    :validation-schema="validationSchema"
    @submit.prevent="submit"
  >
    <div class="box">
      <h1 class="title">Organisation Details</h1>
      <ValidatedInput name="name" type="text" :show-error="showErrors" />
      <ValidatedBaseSelect
        name="baseId"
        label="kaibosh base"
        placeholder="Select a base..."
        :show-error="showErrors"
      />
      <ValidatedAddress
        name="physicalAddress"
        type="text"
        label="physical address"
        :show-error="showErrors"
      />
      <ValidatedDate
        name="startDate"
        label="start date"
        :show-error="showErrors"
        placeholder="Click to select..."
      />
      <ValidatedInput
        name="description"
        type="textarea"
        :show-error="showErrors"
      />
    </div>

    <div class="box">
      <h1 class="title">Primary Contact Details</h1>

      <ValidatedInput
        name="contactName"
        label="contact name"
        type="text"
        :show-error="showErrors"
      />
      <ValidatedInput
        name="contactEmail"
        label="contact email"
        type="text"
        :show-error="showErrors"
      />
      <ValidatedInput
        name="contactPhoneLandline"
        label="contact phone (landline)"
        type="text"
        :show-error="showErrors"
      />
      <ValidatedInput
        name="contactPhoneMobile"
        label="contact phone (mobile)"
        type="text"
        :show-error="showErrors"
      />
      <!-- <ValidatedInput v-model="recipientDetails.contact.name" label="contact name" /> -->
      <!-- <ValidatedInput v-model="recipientDetails.contact.email" label="contact email" :rules="{ email: true }" /> -->
      <!-- <ValidatedInput v-model="recipientDetails.contact.phoneLandline" label="contact landline" /> -->
      <!-- <ValidatedInput v-model="recipientDetails.contact.phoneMobile" label="contact mobile" /> -->
    </div>
    <SubmitButton
      :is-submitting="isSubmitting"
      class="button is-primary is-pulled-right"
      label="Save Recipient"
    />
  </form>
</template>
