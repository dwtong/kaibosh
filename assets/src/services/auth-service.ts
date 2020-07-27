import { post, put, destroy } from "./api-service";
import { ILoginCreds } from "@/types";

const resource = "auth";

export default {
  signIn: (params: ILoginCreds) => {
    return post(`${resource}/sign_in`, params);
  },
  signOut: () => destroy(`${resource}/sign_out`),
  resetPassword: (email: string) => {
    return post(`${resource}/reset_password`, {
      email,
      redirectUrl: `${window.location.origin}/reset_password`
    });
  },
  changePassword: (password: string, token: string) => {
    return put(`${resource}/update_password`, {
      password,
      token: token
    });
  }
};
