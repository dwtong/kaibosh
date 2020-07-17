import { post, destroy } from "./api-service";

export default {
  create: (recipientId: string, hold: object) => post(`recipients/${recipientId}/holds/`, { hold }),
  destroy: (recipientId: string, holdId: string) => destroy(`recipients/${recipientId}/holds/${holdId}`)
};
