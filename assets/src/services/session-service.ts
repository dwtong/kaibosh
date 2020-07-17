import { get } from "./api-service";

export default {
  getForBase: (baseId: string) => {
    return get(`bases/${baseId}/sessions`);
  }
  // get: (id: string) => get(`${resource}/${id}`)
};
