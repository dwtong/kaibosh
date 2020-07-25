import { get } from "./api-service";

export default {
  getForBase: (baseId: string, weekOfDate: string) => {
    return get(`bases/${baseId}/plans`, { weekOfDate });
  },
  getForSession: (baseId: string, sessionId: string, date: string) => {
    return get(`bases/${baseId}/plans/${sessionId}`, { date });
  }
};
