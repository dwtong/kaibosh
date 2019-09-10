import { post, destroy } from "./api-service";
import { ILoginCreds } from "@/types";

const resource = "auth";

export default {
  signIn: (params: ILoginCreds) => {
    return post(`${resource}/sign_in`, params);
  },
  signOut: () => destroy(`${resource}/sign_out`)
};
