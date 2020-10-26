import { get } from "./api-service";

const resource = "/signup/bases";

export default {
  get: () => {
    return get(resource);
  }
};
