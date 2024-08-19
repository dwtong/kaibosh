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
import type { Recipient } from "@/api/recipients"

const props = defineProps<{
  recipient?: Recipient
  onSubmit: (recipient: Partial<Recipient>) => Promise<void>
}>()

console.log(props.recipient?.physicalAddress)

const defaults = {
  name: props.recipient?.name || "",
  baseId: props.recipient?.baseId.toString() || "",
  description: props.recipient?.description || "",
  contactName: props.recipient?.contact.name || "",
  contactEmail: props.recipient?.contact.email || "",
  contactPhoneLandline: props.recipient?.contact.phoneLandline || "",
  contactPhoneMobile: props.recipient?.contact.phoneMobile || "",
  physicalAddress: props.recipient?.physicalAddress || "",
  startDate: props.recipient?.startedAt
    ? new Date(props.recipient?.startedAt)
    : null,
}

const validationSchema = toTypedSchema(
  object({
    name: string().nonempty("Name is required").default(defaults.name),
    baseId: string().nonempty("Base is required").default(defaults.baseId),
    description: string().optional().default(defaults.description),
    startDate: date().optional().nullable().default(defaults.startDate),
    contactName: string().optional().default(defaults.contactName),
    contactEmail: string()
      .email()
      .optional()
      .nullable()
      .default(defaults.contactEmail || null),
    contactPhoneLandline: string()
      .optional()
      .default(defaults.contactPhoneLandline),
    contactPhoneMobile: string()
      .optional()
      .default(defaults.contactPhoneMobile),
    physicalAddress: string().optional().default(defaults.physicalAddress),
  }),
)
const { handleSubmit, submitCount } = useForm({
  validationSchema,
})
const showErrors = computed(() => submitCount.value > 0)
const isSubmitting = ref(false)
const submit = handleSubmit(async (recipientParams) => {
  isSubmitting.value = true
  const {
    baseId,
    contactName,
    contactEmail,
    contactPhoneMobile,
    contactPhoneLandline,
    startDate,
    ...recipientDetails
  } = recipientParams
  const recipient: Partial<Recipient> = {
    ...recipientDetails,
    baseId: parseInt(baseId),
    startedAt: startDate,
    contact: {
      name: contactName || "",
      email: contactEmail || "",
      phoneMobile: contactPhoneMobile || "",
      phoneLandline: contactPhoneLandline || "",
    },
  }
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
        :value="defaults.physicalAddress"
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
