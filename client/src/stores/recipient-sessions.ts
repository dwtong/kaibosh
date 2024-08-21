import { ref } from "vue"
import { defineStore } from "pinia"
import {
  getForRecipient,
  type RecipientSession,
} from "@/api/recipient-sessions"
import { sortBy } from "es-toolkit"
import { dayIndexFromString } from "@/utils/date"

export const useRecipientSessionsStore = defineStore(
  "recipient-sessions",
  () => {
    const recipientSessions = ref<RecipientSession[]>([])

    async function fetchRecipientSessions(recipientId: string) {
      await getForRecipient(recipientId).then((data) => {
        const sessions = sortBy(data, [
          (s) => dayIndexFromString(s.day),
          (s) => s.time,
        ])
        recipientSessions.value = sessions
      })
    }

    return {
      fetchRecipientSessions,
      recipientSessions,
    }
  },
)
