import { get, post, put, destroy } from "./api-service";

const resource = "sessions/scheduled";

export default {
  all: () => get(resource),
  getForRecipient: (id: string) => get(`${resource}`, { recipient_id: id }),
  getForSession: (id: string) => get(`${resource}`, { session_slot_id: id }),
  create: (params: object) => post(resource, params),
  update: (id: string, params: object) => put(`${resource}/${id}`, params),
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
