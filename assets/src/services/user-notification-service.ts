import { get, post, destroy } from "./api-service";

// FIXME Currently API ignores user ID but it is still required
const resource = "users/1/notifications";

export default {
  list: () => get(resource),
  create: (baseId: string) => {
    return post(`${resource}/`, { baseId: baseId });
  },
  delete: (notificationId: string) => {
    return destroy(`${resource}/${notificationId}`);
  }
};
