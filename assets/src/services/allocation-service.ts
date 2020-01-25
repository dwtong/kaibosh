import { get } from "./api-service";

const resource = "allocations";

export default {
  getForSessionSlot: (id: string, date?: string) => {
    const params: any = { session_slot_id: id };

    if (date && date.length > 0) {
      params.date = date;
    }

    return get(`${resource}`, params);
  }
};
