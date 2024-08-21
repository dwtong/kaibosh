import { getSessionsForBase, type Session } from "@/api/sessions"
import { defineStore } from "pinia"
import { ref } from "vue"

export const useSessionsStore = defineStore("sessions", () => {
  const sessions = ref<Session[]>([])
  const currentBaseId = ref<string>("")

  async function fetchSessionsForBase(baseId: string) {
    if (sessions.value?.length && baseId == currentBaseId.value) {
      return
    }
    await getSessionsForBase(baseId).then((data) => (sessions.value = data))
    currentBaseId.value = baseId
  }

  return {
    fetchSessionsForBase,
    sessions,
  }
})
