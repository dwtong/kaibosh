<script setup lang="ts">
import { computed } from 'vue'

type Props = {
  isSubmitting: boolean
  type?: string
}

const props = withDefaults(defineProps<Props>(), {
  type: 'is-primary',
})

const cssClass = computed(() => {
  return {
    'is-loading': props.isSubmitting,
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
    <slot>Submit</slot>
  </button>
</template>
