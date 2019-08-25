import { post, destroy } from "./api-service";

const resource = "sessions/holds";

export default {
  destroy: (id: string) => destroy(`${resource}/${id}`),
  create: (params: object) => post(resource, { session_hold: params })
};
