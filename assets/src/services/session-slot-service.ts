import { get } from "./api-service";

const resource = "sessions/slots";

export default {
  getForBase: (baseId: string, date?: string) => {
    const params: { weekOfDate?: string; baseId: string } = {
      baseId: baseId
    };

    if (date && date.length > 0) {
      params.weekOfDate = date;
    }

    return get(resource, params);
  },
  get: (id: string) => get(`${resource}/${id}`)
};
