import { get } from "./api-service";

const resource = "allocations";

export default {
  getForSessionSlot: (id: string) => get(`${resource}`, { session_slot_id: id })
};
