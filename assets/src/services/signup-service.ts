import { IRecipient } from "@/types";
import { post } from "./api-service";

const resource = "signup";

export default {
  create: (recipient: IRecipient) => post(resource, { recipient }),
};
