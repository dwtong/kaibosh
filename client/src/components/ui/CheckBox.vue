<script setup lang="ts">
import { useAppStore } from "@/stores/app"

const props = defineProps<{
  value: boolean
  label: string
  disabled?: boolean
}>()

defineEmits<{
  (e: "input", value: boolean): void
}>()

const appStore = useAppStore()
appStore.fetchBases()
</script>

<template>
  <div class="field">
    <label class="b-checkbox checkbox" :disabled="disabled ? true : null">
      <input
        type="checkbox"
        :value="props.value"
        :checked="props.value"
        @change="$emit('input', !props.value)"
      />
      <span class="check is-info"></span>
      <span class="control-label">{{ props.label }}</span>
    </label>
  </div>
</template>
