<script setup lang="ts">
import { computed, ref } from 'vue'
import SubmitButton from '../ui/SubmitButton.vue'
import ValidatedInput from '../ui/ValidatedInput.vue'
import { useForm } from 'vee-validate'
import * as yup from 'yup'

const props = defineProps<{
  onSubmit: (password: string) => Promise<void>
}>()
const validationSchema = yup.object({
  password: yup.string().required().min(6),
  confirmation: yup
    .string()
    .required()
    .min(8)
    .oneOf([yup.ref('password')], 'Passwords must match'),
})
const isSubmitting = ref(false)
const { handleSubmit, submitCount } = useForm({
  validationSchema,
})
const showErrors = computed(() => submitCount.value > 0)
const submit = handleSubmit(async ({ password }) => {
  isSubmitting.value = true
  await props.onSubmit(password)
  isSubmitting.value = false
})
</script>

<template>
  <h1 class="title">Update Password</h1>
  <form class="form" @submit.prevent="submit">
    <ValidatedInput name="password" type="password" :show-error="showErrors" />
    <ValidatedInput
      label="password confirmation"
      name="confirmation"
      type="password"
      :show-error="showErrors"
    />
    <SubmitButton :is-submitting="isSubmitting" />
  </form>
</template>
