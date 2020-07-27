import { get, post, put } from "./api-service";

const resource = "users";

export default {
  get: () => get(resource),
  createUser: (email: string) => {
    return post(`${resource}/`, { user: { email } });
  },
  updateUser: (user: any) => {
    return put(`${resource}/me`, { user });
  }
};
