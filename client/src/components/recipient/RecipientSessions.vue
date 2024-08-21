<script setup lang="ts">
import type { RecipientSession } from "@/api/recipient-sessions"
import RecipientSessionCard from "./RecipientSessionCard.vue"
import SessionModal from "./SessionModal.vue"
import HoldModal from "./HoldModal.vue"
import { computed } from "vue"

const props = defineProps<{
  recipientSessions?: RecipientSession[]
  deleteHold: (holdId: string) => void
  deleteSession: (sessionId: string) => void
  updateSession: (session: RecipientSession) => void
  isLoading: boolean
}>()

const canAddHold = computed(() => {
  return props.isLoading || props.recipientSessions?.length === 0
})
</script>

<template>
  <div class="box">
    <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>
    <div v-if="!isLoading">
      <div class="buttons">
        <SessionModal v-slot="{ open }" :recipient-sessions="recipientSessions">
          <button class="button is-info" @click="open">
            Add Sorting Session
          </button>
        </SessionModal>
        <HoldModal v-slot="{ open }">
          <button
            :disabled="canAddHold"
            :title="
              canAddHold
                ? 'Hold date cannot be added when recipient has no sessions'
                : ''
            "
            class="button is-warning"
            @click="open"
          >
            Add Hold
          </button>
        </HoldModal>
      </div>
      <div
        v-for="recipientSession in recipientSessions"
        :key="recipientSession.id"
        class="sessions-box"
      >
        <RecipientSessionCard
          :recipient-session="recipientSession"
          :delete-hold="deleteHold"
          :update-session="updateSession"
          :delete-session="deleteSession"
        />
      </div>
    </div>
  </div>
</template>
