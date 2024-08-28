<script setup lang="ts">
export type MessageBoxType =
  | "is-dark"
  | "is-link"
  | "is-info"
  | "is-primary"
  | "is-success"
  | "is-warning"
  | "is-danger"

defineProps<{
  type: MessageBoxType
  title: string
}>()
</script>

<template>
  <article class="message" :class="type">
    <div class="message-header">
      <p>{{ title }}</p>
      <button class="delete" aria-label="delete"></button>
    </div>
    <div class="message-body">
      <slot></slot>
    </div>
  </article>
</template>
