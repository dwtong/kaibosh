import { get, post, put, destroy } from "./api-service";

const resource = "sessions/scheduled";

export default {
  all: () => get(resource),
  getForRecipient: (id: string) => get(`${resource}`, { recipientId: id }),
  getForSession: (id: string) => get(`${resource}`, { sessionSlotId: id }),
  create: (params: object) => post(resource, params),
  update: (id: string, params: object) => put(`${resource}/${id}`, params),
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
