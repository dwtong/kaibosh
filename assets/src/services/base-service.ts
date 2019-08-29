import { get } from "./api-service";

const resource = "bases";

export default {
  get: () => get(resource)
};
