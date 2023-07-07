<script setup lang="ts">
import { computed } from 'vue'
import SubmitButton from '../ui/SubmitButton.vue'
import ValidatedInput from '../ui/ValidatedInput.vue'
import { useForm } from 'vee-validate'
import * as yup from 'yup'
import { updatePassword } from '@/api/auth'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()
const { handleSubmit, isSubmitting, submitCount } = useForm({
  validationSchema: yup.object({
    password: yup.string().required().min(6),
    confirmation: yup
      .string()
      .required()
      .min(8)
      .oneOf([yup.ref('password')], 'Passwords must match'),
  }),
})
const showErrors = computed(() => submitCount.value > 0)
const onSubmit = handleSubmit(async ({ password }) => {
  const token = route.query?.password_reset_token?.toString() ?? ''
  const { email } = await updatePassword({ token, password })
  await auth.login({ email, password })
})
</script>

<template>
  <h1 class="title">Update Password</h1>
  <form class="form" @submit.prevent="onSubmit">
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
