import { IRecipient } from "@/types";
import { get, post, put, destroy } from "./api-service";

const resource = "recipients";

export default {
  all: () => get(resource),
  get: (id: string) => get(`${resource}/${id}`),
  create: (params: IRecipient) => post(resource, params),
  update: (id: string, recipient: any) => put(`${resource}/${id}`, { recipient }),
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
