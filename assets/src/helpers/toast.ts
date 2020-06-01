import { ToastProgrammatic as Toast } from "buefy";

export default {
  error(errorMsg: string, formError?: boolean) {
    Toast.open({
      message: `${errorMsg} ${formError ? "Please see form errors." : "Please try again later or contact support."}`,
      type: "is-danger",
      position: "is-top",
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
