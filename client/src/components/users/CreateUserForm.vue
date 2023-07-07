<script setup lang="ts">
import { computed, ref } from 'vue'
import SubmitButton from '../ui/SubmitButton.vue'
import ValidatedInput from '../ui/ValidatedInput.vue'
import { useForm } from 'vee-validate'
import * as yup from 'yup'
import { postUser } from '@/api/users'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const isSubmitting = ref(false)
const validationSchema = yup.object({
  email: yup.string().required().email(),
})
const { handleSubmit, submitCount } = useForm({
  validationSchema,
})
const showErrors = computed(() => submitCount.value > 0)

const submit = handleSubmit(async ({ email }) => {
  isSubmitting.value = true

  await postUser({ email })
  await userStore.fetchUsers()

  isSubmitting.value = false
})
</script>

<template>
  <form class="form" @submit.prevent="submit">
    <ValidatedInput name="email" type="email" :show-error="showErrors" />
    <SubmitButton :is-submitting="isSubmitting" />
  </form>
</template>
