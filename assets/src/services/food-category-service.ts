import { get } from "./api-service";

export default {
  get: (baseId: string) => get(`bases/${baseId}/categories`)
};
