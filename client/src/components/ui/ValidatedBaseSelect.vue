<script setup lang="ts">
import { useField } from "vee-validate"
import BaseSelect from "./BaseSelect.vue"

const props = defineProps<{
  label?: string
  name: string
  showError?: boolean
}>()

const { errorMessage, value, setValue } = useField<string>(() => props.name)

function onInput(event: Event) {
  const { value } = event.target as HTMLInputElement
  setValue(value)
}
</script>

<template>
  <div class="field">
    <label class="label">{{ label || "base" }}</label>
    <BaseSelect :value="value" @input="onInput" />
    <p v-if="showError && errorMessage" class="error-msg">{{ errorMessage }}</p>
  </div>
</template>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
