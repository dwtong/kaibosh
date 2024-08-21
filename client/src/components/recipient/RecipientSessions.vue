<script setup lang="ts">
import type { RecipientSession } from "@/api/recipient-sessions"
import RecipientSessionCard from "./RecipientSessionCard.vue"
import SessionModal from "./SessionModal.vue"
import HoldModal from "./HoldModal.vue"
import { computed, ref } from "vue"
import ModalConfirmation from "../ui/ModalConfirmation.vue"

const props = defineProps<{
  recipientSessions?: RecipientSession[]
  recipientId: string
  deleteHold: (holdId: string) => void
  deleteSession: (sessionId: string) => Promise<void>
  updateSession: (session: RecipientSession) => Promise<void>
  isLoading: boolean
}>()

const canAddHold = computed(() => {
  return props.isLoading || props.recipientSessions?.length === 0
})
const deleteConfirmationIsOpen = ref(false)
const updateConfirmationIsOpen = ref(false)
const modalRecipientSessionId = ref()

function openUpdateModal(recipientSessionId: string) {
  updateConfirmationIsOpen.value = true
  modalRecipientSessionId.value = recipientSessionId
}

function openDeleteModal(recipientSessionId: string) {
  deleteConfirmationIsOpen.value = true
  modalRecipientSessionId.value = recipientSessionId
}

function deleteSessionAndCloseModal() {
  props.deleteSession(modalRecipientSessionId.value).then(() => {
    deleteConfirmationIsOpen.value = false
  })
}
</script>

<template>
  <div class="box">
    <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>
    <div v-if="!isLoading">
      <div class="buttons">
        <SessionModal
          v-slot="{ open }"
          :recipient-sessions="recipientSessions"
          :recipient-id="recipientId"
        >
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
        <ModalConfirmation
          submit-button="Delete"
          type="is-danger"
          :is-open="deleteConfirmationIsOpen"
          @close="deleteConfirmationIsOpen = false"
          @submit="deleteSessionAndCloseModal"
        >
          Are you sure you wish to delete this session?
        </ModalConfirmation>
      </div>
      <div
        v-for="recipientSession in recipientSessions"
        :key="recipientSession.id"
        class="sessions-box"
      >
        <RecipientSessionCard
          :recipient-session="recipientSession"
          :delete-hold="deleteHold"
          :open-update-modal="openUpdateModal"
          :open-delete-modal="openDeleteModal"
        />
      </div>
    </div>
  </div>
</template>
