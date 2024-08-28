<script lang="ts" setup>
import { computed } from "vue"

const props = defineProps<{
  status: string
}>()
const statusLabel = computed(() => props.status.replace("_", " "))
const labelType = computed(() => {
  return props.status == "on_hold" ? "is-warning" : "is-primary"
})
</script>

<template>
  <span class="tag is-rounded is-medium" :class="labelType">{{
    statusLabel
  }}</span>
</template>
