import { get, post, put, destroy } from "./api-service";

export default {
  getForRecipient: (recipientId: string) => get(`recipients/${recipientId}/sessions`),
  create: (recipientId: string, params: object) => post(`recipients/${recipientId}/sessions`, params),
  update: (recipientId: string, id: string, params: object) => put(`recipients/${recipientId}/sessions/${id}`, params),
  destroy: (recipientId: string, id: string) => destroy(`recipients/${recipientId}/sessions/${id}`),
  createHold: (recipientId: string, hold: object) => post(`recipients/${recipientId}/holds/`, { hold }),
  destroyHold: (recipientId: string, holdId: string) => destroy(`recipients/${recipientId}/holds/${holdId}`)
};
