<script setup lang="ts">
import { computed, ref } from 'vue'
import SubmitButton from '../ui/SubmitButton.vue'
import ValidatedInput from '../ui/ValidatedInput.vue'
import { useForm } from 'vee-validate'
import * as yup from 'yup'

const isSubmitting = ref(false)
const { handleSubmit, submitCount } = useForm({
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
const onSubmit = handleSubmit(({ password }) => {
  console.log(password)
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
