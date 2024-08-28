<script setup lang="ts">
import {
  createRecipientSession,
  destroyHold,
  destroyRecipientSession,
  updateRecipientSession,
  type RecipientSessionParams,
} from "@/api/recipient-sessions"
import RecipientSessionCard from "./RecipientSessionCard.vue"
import SessionModal from "./SessionModal.vue"
import HoldModal from "./HoldModal.vue"
import { computed, ref } from "vue"
import ModalConfirmation from "../ui/ModalConfirmation.vue"
import { toast } from "@/utils/toast"
import { useRecipientSessionsStore } from "@/stores/recipient-sessions"
import { storeToRefs } from "pinia"
import { useRecipientsStore } from "@/stores/recipients"

const props = defineProps<{
  recipientId: string
  isLoading: boolean
}>()
const { fetchRecipient } = useRecipientsStore()
const recipientSessionsStore = useRecipientSessionsStore()
const { recipientSessions } = storeToRefs(recipientSessionsStore)

async function createSession(sessionParams: RecipientSessionParams) {
  try {
    await createRecipientSession(props.recipientId, sessionParams)
    await Promise.all([
      recipientSessionsStore.fetchRecipientSessions(props.recipientId),
      fetchRecipient(props.recipientId),
    ])
    toast({ message: "Session created", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to create session", type: "is-danger" })
  }
}

async function updateSession(
  recipientSessionId: string,
  params: RecipientSessionParams,
) {
  try {
    await updateRecipientSession(props.recipientId, recipientSessionId, params)
    await Promise.all([
      recipientSessionsStore.fetchRecipientSessions(props.recipientId),
      fetchRecipient(props.recipientId),
    ])
    toast({ message: "Session updated", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to update session", type: "is-danger" })
  }
}

async function deleteSession() {
  try {
    await destroyRecipientSession(
      props.recipientId,
      selectedRecipientSessionId.value,
    )
    await Promise.all([
      recipientSessionsStore.fetchRecipientSessions(props.recipientId),
      fetchRecipient(props.recipientId),
    ])
    toast({ message: "Session deleted", type: "is-success" })
    deleteConfirmationIsOpen.value = false
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to delete session.", type: "is-danger" })
  }
}

async function deleteHold(holdId: string) {
  try {
    await destroyHold(props.recipientId, holdId)
    await Promise.all([
      recipientSessionsStore.fetchRecipientSessions(props.recipientId),
      fetchRecipient(props.recipientId),
    ])
    toast({ message: "Hold deleted.", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to delete hold.", type: "is-danger" })
  }
}

const canAddHold = computed(() => {
  return !props.isLoading && recipientSessions.value.length > 0
})
const deleteConfirmationIsOpen = ref(false)
const selectedRecipientSessionId = ref()

function openDeleteModal(recipientSessionId: string) {
  deleteConfirmationIsOpen.value = true
  selectedRecipientSessionId.value = recipientSessionId
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
          @submit="createSession"
        >
          <button class="button is-info" @click="open">
            Add Sorting Session
          </button>
        </SessionModal>
        <HoldModal
          v-slot="{ open }"
          :recipient-sessions="recipientSessions"
          :recipient-id="recipientId"
        >
          <button
            :disabled="!canAddHold"
            :title="
              canAddHold
                ? 'Hold date cannot be added when recipient has no sessions'
                : ''
            "
            class="button is-warning"
            @click="open"
          >
            Add Hold Date
          </button>
        </HoldModal>
        <ModalConfirmation
          submit-button="Delete"
          type="is-danger"
          :is-open="deleteConfirmationIsOpen"
          @close="deleteConfirmationIsOpen = false"
          @submit="deleteSession"
        >
          Are you sure you wish to delete this session?
        </ModalConfirmation>
      </div>
      <div
        v-for="recipientSession in recipientSessions"
        :key="recipientSession.id"
        class="sessions-box"
      >
        <SessionModal
          v-slot="{ open }"
          :recipient-sessions="recipientSessions"
          :recipient-id="recipientId"
          :existing-session="recipientSession"
          @submit="(params) => updateSession(recipientSession.id, params)"
        >
          <RecipientSessionCard
            :recipient-session="recipientSession"
            :delete-hold="deleteHold"
            :open-update-modal="open"
            :open-delete-modal="openDeleteModal"
          />
        </SessionModal>
      </div>
    </div>
  </div>
</template>
