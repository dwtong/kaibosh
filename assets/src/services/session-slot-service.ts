import { get, post, put } from "./api-service";

const resource = "sessions/slots";

export default {
  get: (baseId: string) => get(resource, { base_id: baseId })
};
