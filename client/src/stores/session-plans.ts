import { getSessionPlansForBase, type SessionPlan } from "@/api/sessions"
import { formatDate } from "@/utils/date"
import { capitalize, sortBy } from "es-toolkit"
import { defineStore } from "pinia"
import { ref } from "vue"

export const useSessionPlansStore = defineStore("session-plans", () => {
  const planList = ref<SessionPlan[]>([])

  async function fetchPlanList(baseId: string, weekOfDate: Date) {
    const weekOfDateString = formatDate(weekOfDate, "yyyy-MM-dd")
    await getSessionPlansForBase(baseId, weekOfDateString).then((data) => {
      planList.value = data
    })
  }

  function plansForDay(day: string) {
    return sortBy(
      planList.value?.filter((p) => capitalize(p.session.day) === day),
      [(p) => p.session.time],
    )
  }

  return {
    fetchPlanList,
    plansForDay,
  }
})
