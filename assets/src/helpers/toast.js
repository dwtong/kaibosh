import { Toast } from "buefy/dist/components/toast";

export default {
  error(errorMsg, items) {
    Toast.open({
      message: `${errorMsg} ${
        items && items.length > 0
          ? "Please see form errors."
          : "Please try again later or contact support."
      }`,
      type: "is-danger",
      position: "is-bottom"
    });
  },

  success(msg) {
    Toast.open({
      message: msg,
      type: "is-success",
      position: "is-top"
    });
  }
};
