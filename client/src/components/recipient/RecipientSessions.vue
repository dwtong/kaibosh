<script setup lang="ts">
import type { RecipientSession } from "@/api/recipient-sessions"
import RecipientSessionCard from "./RecipientSessionCard.vue"

defineProps<{
  sessions?: RecipientSession[]
}>()
defineEmits<{
  (e: "input", name: string, value: boolean): void
}>()

const loading = false
</script>

<template>
  <div class="box">
    <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>
    <div v-if="!loading">
      <div v-for="session in sessions" :key="session.id" class="sessions-box">
        <RecipientSessionCard :session="session" />
      </div>
    </div>
  </div>
</template>
