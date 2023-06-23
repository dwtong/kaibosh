import { post, put, destroy } from "./api"

export type LoginCreds = {
  email: string;
  password: string;
}

const resource = "auth";

export function signIn(params: LoginCreds) {
  return post(`${resource}/sign_in`, params);
}

export function signOut() {
  destroy(`${resource}/sign_out`)
}

export function resetPassword(email: string) {
  return post(`${resource}/reset_password`, {
    email,
    redirectUrl: `${window.location.origin}/reset_password`
  });
}

export function changePassword(password: string, token: string) {
  return put(`${resource}/update_password`, {
    password,
    token: token
  });
}
