import { get } from "./api-service";

const resource = "food-categories";

export default {
  get: () => get(resource)
};
