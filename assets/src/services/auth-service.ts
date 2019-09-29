import { post, put, destroy } from "./api-service";
import { ILoginCreds } from "@/types";

const resource = "auth";

export default {
  signIn: (params: ILoginCreds) => {
    return post(`${resource}/sign_in`, params);
  },
  createUser: (email: string) => {
    const password = Math.random().toString(36);

    return post(`${resource}/`, {
      email,
      password,
      password_confirmation: password,
      confirm_success_url: `${window.location.origin}/`
    });
  },
  resetPassword: (email: string) => {
    return post(`${resource}/password`, {
      email,
      redirect_url: `${window.location.origin}/reset_password`
    });
  },
  changePassword: (password: string, confirmation: string) => {
    return put(`${resource}/password`, {
      password,
      password_confirmation: confirmation
    });
  },
  signOut: () => destroy(`${resource}/sign_out`)
};
