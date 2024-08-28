import api from "./api"
import type { SessionAllocation } from "./recipient-sessions"

export type Session = {
  id: string
  day: string
  time: string
}

export type SessionPlan = {
  session: Session & { date: string }
  recipients: SessionRecipient[]
}

export type SessionPlanDetails = SessionPlan & {
  allocations: SessionAllocation[]
}

export type SessionRecipient = {
  id: string
  description: string
  name: string
  status: string
}

export async function getSessionsForBase(baseId: string): Promise<Session[]> {
  return api.get(`bases/${baseId}/sessions`).then(({ data }) => data)
}

export async function getSessionPlansForBase(
  baseId: string,
  weekOfDate: string,
): Promise<SessionPlan[]> {
  return api
    .get(`bases/${baseId}/plans?week_of_date=${weekOfDate}`)
    .then(({ data }) => data)
}

export async function getPlanForSession(
  baseId: string,
  sessionId: string,
  date: string,
): Promise<SessionPlanDetails> {
  return api
    .get(`bases/${baseId}/plans/${sessionId}?date=${date}`)
    .then(({ data }) => data)
}
