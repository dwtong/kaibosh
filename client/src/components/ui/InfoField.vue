<script setup lang="ts">
defineProps<{ label: string }>()
</script>

<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <div class="control">
      <p class="text">
        <slot></slot>
      </p>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.field {
  margin-top: 1.5rem;
  .text {
    margin-left: 0.2rem;
  }
}
</style>
