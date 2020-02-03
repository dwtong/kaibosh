import { get, post, put } from "./api-service";

const resource = "sessions/slots";

export default {
  getForBase: (baseId: string, date?: string) => {
    const params: { week_of_date?: string; base_id: string } = {
      base_id: baseId
    };

    if (date && date.length > 0) {
      params.week_of_date = date;
    }

    return get(resource, params);
  },
  get: (id: string) => get(`${resource}/${id}`)
};
