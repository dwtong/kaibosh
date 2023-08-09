<script setup lang="ts">
import { computed, ref } from "vue"
import SubmitButton from "../ui/SubmitButton.vue"
import ValidatedInput from "../ui/ValidatedInput.vue"
import { useForm } from "vee-validate"
import { object, string } from "zod"
import { toTypedSchema } from "@vee-validate/zod"
import { postUser } from "@/api/users"
import { useUserStore } from "@/stores/user"

const userStore = useUserStore()
const isSubmitting = ref(false)
const validationSchema = toTypedSchema(
  object({
    email: string()
      .nonempty("Email is required")
      .email("Must be a valid email"),
  }),
)
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
