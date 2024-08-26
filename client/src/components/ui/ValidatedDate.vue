<script setup lang="ts">
import { useField } from "vee-validate"
import { computed, onMounted, watch } from "vue"
import { Datepicker } from "vanillajs-datepicker"

const props = defineProps<{
  name: string
  label?: string
  placeholder?: string
  showError?: boolean
  disabled?: boolean
  default?: Date
}>()

const { errorMessage, value, setValue } = useField<string | null>(props.name)
let datepicker: Datepicker

onMounted(() => {
  const element = document.querySelector(
    `input[name="${props.name}"]`,
  ) as HTMLElement
  datepicker = new Datepicker(element, {
    autohide: true,
    format: "dd/mm/yyyy",
    clearButton: true,
  })
  element.addEventListener("changeDate", (ev) => {
    const { date } = (ev as CustomEvent).detail
    setValue(date || null)
  })
  datepicker.setDate(value.value)
})

watch(value, () => datepicker.setDate(value.value))
const label = computed(() => props.label || props.name.replace(/-/g, " "))
</script>

<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <div class="control">
      <input
        type="text"
        class="input date datepicker-input"
        :name="name"
        :placeholder="placeholder"
        :disabled="disabled"
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
