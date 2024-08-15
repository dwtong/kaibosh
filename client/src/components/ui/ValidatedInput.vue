<script setup lang="ts">
import { useField } from "vee-validate"
import { computed } from "vue"

const props = defineProps<{
  name: string
  label?: string
  type?: string
  placeholder?: string
  showError?: boolean
}>()

const label = computed(() => props.label || props.name.replace(/-/g, " "))
const { errorMessage, value } = useField<string>(() => props.name)
</script>

<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <div v-if="type === 'textarea'">
      <textarea
        :id="name"
        v-model="value"
        :type="type || 'text'"
        :name="name"
        :placeholder="placeholder"
        class="textarea"
      />
    </div>
    <div v-else class="control">
      <input
        :id="name"
        v-model="value"
        :type="type || 'text'"
        :name="name"
        :placeholder="placeholder"
        class="input"
      />
    </div>
    <p v-if="showError && errorMessage" class="error-msg">{{ errorMessage }}</p>
  </div>
</template>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
