import App from "@/App.vue";
import "@/assets/scss/app.scss";
import "@/class-component-hooks";
import Router from "@/router";
import Store from "@/store";

import Buefy from "buefy";
import Vue, { createApp } from "vue";
import Rollbar from "vue-rollbar";
import LogRocket from "logrocket";
import "./vee-validate";

if (process.env.NODE_ENV === "production") {
  LogRocket.init("7qg6ha/kaibosh-platform");
  const user = localStorage.getItem("uid");

  if (user) {
    LogRocket.identify(user);
  }

  Vue.use(Rollbar, {
    accessToken: "1d62c1d20fcc4120aa42aecbaece2e9b",
    captureUncaught: true,
    captureUnhandledRejections: true,
    enabled: process.env.NODE_ENV === "production",
    environment: process.env.NODE_ENV,
    payload: {
      client: {
        javascript: {
          code_version: "version-1"
        }
      }
    },
    transform: (obj: Record<string, unknown>) => {
      obj.sessionURL = LogRocket.sessionURL;
      return obj;
    }
  });
}

Vue.use(Buefy, {
  defaultIconPack: "fas",
  defaultDateFormatter(date: Date) {
    return date.toLocaleDateString("en-GB");
  }
});

createApp(App).use(Router).use(Store).mount("#app");
