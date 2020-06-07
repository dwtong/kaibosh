import { IRecipient } from "@/types";
import { get, post, put, destroy } from "./api-service";

const resource = "recipients";

export default {
  all: () => get(resource),
  get: (id: string) => get(`${resource}/${id}`),
  create: (params: IRecipient) => {
    return post(resource, { primaryContactAttributes: params.primaryContact, ...params });
  },
  update: (id: string, params: IRecipient) => {
    return put(`${resource}/${id}`, { primaryContactAttributes: params.primaryContact, ...params });
  },
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
