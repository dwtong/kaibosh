import { IRecipient } from "@/types";
import { get, post, put, destroy } from "./api-service";

const resource = "recipients";

export default {
  all: () => get(resource),
  export: (params: object) => get(`${resource}/export`, params),
  get: (id: string) => get(`${resource}/${id}`),
  create: (recipient: IRecipient) => post(resource, { recipient }),
  update: (id: string, recipient: any) => put(`${resource}/${id}`, { recipient }),
  destroy: (id: string) => destroy(`${resource}/${id}`)
};
