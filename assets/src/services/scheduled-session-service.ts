import { get, post, put, destroy } from "./api-service";

const resource = "sessions/scheduled";

export default {
  all: () => get(resource),
  get: (id: string) => get(`${resource}`, { recipient_id: id }),
  create: (params: object) => post(resource, params),
  update: (id: string, params: object) => put(`${resource}/${id}`, params),
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
