import { getSessionsForBase, type Session } from "@/api/sessions"
import { dayIndexFromString } from "@/utils/date"
import { sortBy } from "es-toolkit"
import { defineStore } from "pinia"
import { ref } from "vue"

export const useSessionsStore = defineStore("sessions", () => {
  const sessions = ref<Session[]>([])
  const currentBaseId = ref<string>("")

  async function fetchSessionsForBase(baseId: string) {
    if (sessions.value?.length && baseId == currentBaseId.value) {
      return
    }
    await getSessionsForBase(baseId).then((data) => {
      const sortedSessions = sortBy(data, [
        (s) => dayIndexFromString(s.day),
        (s) => s.time,
      ])
      sessions.value = sortedSessions
    })
    currentBaseId.value = baseId
  }

  return {
    fetchSessionsForBase,
    sessions,
  }
})
