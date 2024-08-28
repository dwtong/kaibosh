<script setup lang="ts">
import { initAddressFinder } from "@/utils/address-finder"
import { useField } from "vee-validate"
import { computed, onMounted } from "vue"

const props = defineProps<{
  name: string
  label?: string
  type?: string
  placeholder?: string
  showError?: boolean
  value: string
}>()

const label = computed(() => props.label || props.name.replace(/-/g, " "))
const { errorMessage, value } = useField<string>(() => props.name)
const addressFinderCallback = (val: string) => (value.value = val)
onMounted(() => initAddressFinder(props.name, addressFinderCallback))
</script>

<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <input
      :id="name"
      :name="name"
      :placeholder="placeholder"
      type="text"
      class="input"
      :value="value"
    />
    <p v-if="showError && errorMessage" class="error-msg">{{ errorMessage }}</p>
  </div>
</template>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
