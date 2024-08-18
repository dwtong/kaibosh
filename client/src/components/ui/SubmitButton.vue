<script setup lang="ts">
import { computed } from "vue"

type Props = {
  isSubmitting: boolean
  type?: string
  label?: string
}

const props = withDefaults(defineProps<Props>(), {
  type: "is-primary",
  label: "Submit",
})

const cssClass = computed(() => {
  return {
    "is-loading": props.isSubmitting,
    [props.type]: true,
  }
})
</script>

<template>
  <button
    type="submit"
    :class="cssClass"
    class="button"
    :disabled="isSubmitting"
  >
    <slot>{{ label }}</slot>
  </button>
</template>
