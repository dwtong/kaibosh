import { get } from "./api-service";

const resource = "users";

export default {
  get: () => get(resource)
};
