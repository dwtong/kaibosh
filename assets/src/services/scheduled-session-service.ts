import { get, post, put, destroy } from "./api-service";

export default {
  // all: () => get(resource),
  // getForSession: (id: string) => get(`${resource}`, { sessionId: id }),
  getForRecipient: (recipientId: string) => get(`recipients/${recipientId}/sessions`),
  create: (recipientId: string, params: object) => post(`recipients/${recipientId}/sessions`, params),
  update: (recipientId: string, id: string, params: object) => put(`recipients/${recipientId}/sessions/${id}`, params),
  destroy: (recipientId: string, id: string) => destroy(`recipients/${recipientId}/sessions/${id}`)
};
