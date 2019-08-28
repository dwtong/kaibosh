// @ts-ignore
import { Toast } from "buefy/dist/components/toast";

export default {
  error(errorMsg: string, items?: []) {
    Toast.open({
      message: `${errorMsg} ${
        items && items.length > 0
          ? "Please see form errors."
          : "Please try again later or contact support."
      }`,
      type: "is-danger",
      position: "is-bottom",
      duration: 10000
    });
  },

  success(msg: string) {
    Toast.open({
      message: msg,
      type: "is-success",
      position: "is-top"
    });
  }
};
