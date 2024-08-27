import api from "./api"

export type Session = {
  id: string
  day: string
  time: string
}

export type SessionPlan = {
  session: Session & { date: string }
  recipients: SessionRecipient[]
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
