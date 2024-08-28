<script setup lang="ts">
defineProps<{
  direction: "asc" | "desc"
}>()
</script>

<template>
  <span v-if="direction === 'asc'" class="icon is-small">
    <i class="fas fa-arrow-up"></i>
  </span>
  <span v-if="direction === 'desc'" class="icon is-small">
    <i class="fas fa-arrow-down"></i>
  </span>
</template>
