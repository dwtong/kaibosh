import { get } from "./api-service";

const resource = "bases";

export default {
  get: () => {
    return get(resource);
  }
};
