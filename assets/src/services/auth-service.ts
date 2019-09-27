import { post, put, destroy } from "./api-service";
import { ILoginCreds } from "@/types";

const resource = "auth";

export default {
  signIn: (params: ILoginCreds) => {
    return post(`${resource}/sign_in`, params);
  },
  changePassword: (password: string, confirmation: string) => {
    return put(`${resource}/password`, {
      password,
      password_confirmation: confirmation
    });
  },
  signOut: () => destroy(`${resource}/sign_out`)
};
