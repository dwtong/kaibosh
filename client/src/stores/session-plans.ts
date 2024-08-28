import {
  getPlanForSession,
  getSessionPlansForBase,
  type SessionPlan,
  type SessionPlanDetails,
} from "@/api/sessions"
import { formatDate } from "@/utils/date"
import { capitalize, sortBy } from "es-toolkit"
import { defineStore } from "pinia"
import { computed, ref } from "vue"

export const useSessionPlansStore = defineStore("session-plans", () => {
  const planList = ref<SessionPlan[]>([])
  const planDetails = ref<SessionPlanDetails>()

  const orderedRecipients = computed(() => {
    const recipients = planDetails.value?.recipients || []
    return sortBy(recipients, [(c) => c.name])
  })

  async function fetchPlanDetails(
    baseId: string,
    sessionId: string,
    date: string,
  ) {
    await getPlanForSession(baseId, sessionId, date).then((data) => {
      planDetails.value = data
    })
  }

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

  function allocationsForCategory(categoryId: string) {
    return planDetails.value?.allocations.filter(
      (a) => a.categoryId === categoryId,
    )
  }

  function recipientById(recipientId: string) {
    return planDetails.value?.recipients.find((r) => r.id === recipientId)
  }

  return {
    allocationsForCategory,
    fetchPlanDetails,
    fetchPlanList,
    orderedRecipients,
    plansForDay,
    planDetails,
    recipientById,
  }
})
