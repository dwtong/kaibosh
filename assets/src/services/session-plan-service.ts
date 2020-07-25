import { get } from "./api-service";

export default {
  getForBase: (baseId: string, weekOfDate: string) => {
    return get(`bases/${baseId}/plans`, { weekOfDate });
  }
  // getForSession: (id: string, date?: string) => {
  //   const params: { sessionId: string; date?: string } = { sessionId: id };
  //   if (date && date.length > 0) {
  //     params.date = date;
  //   }
  //   return get(`${resource}`, params);
  // }
};
