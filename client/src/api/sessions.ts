import api from "./api"

export type Session = {
  id: string
  day: string
  time: string
}

export async function getSessionsForBase(baseId: string): Promise<Session[]> {
  return api.get(`bases/${baseId}/sessions`).then(({ data }) => data)
}
