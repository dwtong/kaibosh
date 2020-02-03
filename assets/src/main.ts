import App from "@/App.vue";
import "@/assets/scss/app.scss";
import "@/class-component-hooks";
import Router from "@/router";
import Store from "@/store";

import Buefy from "buefy";
import VeeValidate from "vee-validate";
import VueMoment from "vue-moment";
import Vue from "vue";
import Rollbar from "vue-rollbar";
import LogRocket from "logrocket";

if (process.env.NODE_ENV === "production") {
  LogRocket.init("7qg6ha/kaibosh-platform");

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
    transform: (obj: any) => {
      obj.sessionURL = LogRocket.sessionURL;
      return obj;
    }
  });
}

Vue.use(VeeValidate, { inject: false });

Vue.use(Buefy, {
  defaultIconPack: "fas",
  defaultDateFormatter(date: Date) {
    return date.toLocaleDateString("en-GB");
  }
});

Vue.use(VueMoment);

Vue.config.productionTip = false;

new Vue({
  render: h => h(App),
  router: Router,
  store: Store
}).$mount("#app");
