import { get } from "./api-service";

const resource = "bases";

export default {
  get: () => {
    const x = get(resource);
    console.log(x);
    return x;
  }
};
