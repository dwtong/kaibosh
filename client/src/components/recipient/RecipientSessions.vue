<script setup lang="ts">
import type { RecipientSession } from "@/api/recipient-sessions"
import RecipientSessionCard from "./RecipientSessionCard.vue"

defineProps<{
  sessions?: RecipientSession[]
  deleteHold: (holdId: string) => void
  deleteSession: (sessionId: string) => void
  updateSession: (session: RecipientSession) => void
}>()

const loading = false
</script>

<template>
  <div class="box">
    <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>
    <div v-if="!loading">
      <div v-for="session in sessions" :key="session.id" class="sessions-box">
        <RecipientSessionCard
          :session="session"
          :delete-hold="deleteHold"
          :update-session="updateSession"
          :delete-session="deleteSession"
        />
      </div>
    </div>
  </div>
</template>
