import { get } from "./api-service";

const resource = "allocations";

export default {
  getForSession: (id: string, date?: string) => {
    const params: { sessionId: string; date?: string } = { sessionId: id };

    if (date && date.length > 0) {
      params.date = date;
    }

    return get(`${resource}`, params);
  }
};
