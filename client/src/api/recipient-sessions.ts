import api from "./api"

export type RecipientSession = {
  id: string
  day: string
  time: string
  sessionId: string
  status: string
  allocations: SessionAllocation[]
  holds: SessionHold[]
}

export type SessionAllocation = {
  id: string
  categoryId: string
  quantity: string
}

export type SessionHold = {
  id: string
  startsAt: Date
  endsAt: Date
}

export type RecipientSessionParams = {
  sessionId: string
  recipientId: string
  allocations: Omit<SessionAllocation, "id">[]
}

export async function getForRecipient(
  recipientId: string,
): Promise<RecipientSession[]> {
  return api.get(`recipients/${recipientId}/sessions`).then(({ data }) => data)
}

export async function createRecipientSession(
  recipientId: string,
  params: RecipientSessionParams,
): Promise<RecipientSession> {
  return api
    .post(`recipients/${recipientId}/sessions`, { session: params })
    .then(({ data }) => data)
}

export async function updateRecipientSession(
  recipientId: string,
  id: string,
  params: RecipientSessionParams,
): Promise<RecipientSession> {
  return api
    .put(`recipients/${recipientId}/sessions/${id}`, { session: params })
    .then(({ data }) => data)
}
export async function destroy(recipientId: string, id: string): Promise<void> {
  return api.delete(`recipients/${recipientId}/sessions/${id}`)
}

export async function createHold(
  recipientId: string,
  hold: Omit<SessionHold, "id">,
): Promise<void> {
  return api
    .post(`recipients/${recipientId}/holds/`, { hold })
    .then(({ data }) => data)
}

export async function destroyHold(
  recipientId: string,
  holdId: string,
): Promise<void> {
  return api.delete(`recipients/${recipientId}/holds/${holdId}`)
}
