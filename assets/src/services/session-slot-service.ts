import { get, post, put } from "./api-service";

const resource = "sessions/slots";

export default {
  getForBase: (baseId: string) => get(resource, { base_id: baseId }),
  get: (id: string) => get(`${resource}/${id}`)
};
