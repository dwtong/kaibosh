import { ref } from "vue"
import { defineStore } from "pinia"
import {
  getForRecipient,
  type RecipientSession,
} from "@/api/recipient-sessions"

export const useRecipientSessionsStore = defineStore(
  "recipient-sessions",
  () => {
    const recipientSessions = ref<RecipientSession[]>([])

    async function fetchRecipientSession(recipientId: string) {
      await getForRecipient(recipientId).then(
        (data) => (recipientSessions.value = data),
      )
    }

    return {
      fetchRecipientSession,
      recipientSessions,
    }
  },
)
