import api from "./api"

export type Contact = {
  name: string
  email: string
  phoneLandline: string
  phoneMobile: string
}

export type RecipientSummary = {
  id: string
  baseId: number
  name: string
  status: string
}

export type Recipient = RecipientSummary & {
  description: string
  startedAt: Date | string
  physicalAddress: string
  contact: Contact
  hasMetKaibosh: boolean
  hasSignedTerms: boolean
  archivedAt: Date | string | null
}

export type NewRecipient = Partial<Recipient>

export type ExportRecipientParams = {
  baseId: number
  name: string
  status: string[]
}

export async function getRecipients(): Promise<RecipientSummary[]> {
  return api.get<RecipientSummary[]>("recipients").then(({ data }) => data)
}

export async function getRecipient(id: string): Promise<Recipient> {
  return api.get(`recipients/${id}`).then(({ data }) => data)
}

export async function createRecipient(
  recipient: NewRecipient,
): Promise<Recipient> {
  return api.post("recipients", { recipient }).then(({ data }) => data)
}

export async function updateRecipient(
  id: string,
  recipient: Partial<Recipient>,
): Promise<Recipient> {
  return api.put(`recipients/${id}`, { recipient }).then(({ data }) => data)
}

export async function destroyRecipient(id: string): Promise<void> {
  api.delete(`recipients/${id}`)
}

export async function exportRecipients(
  params: ExportRecipientParams,
): Promise<string> {
  return api.get(`recipients/export`, { params }).then(({ data }) => data)
}
