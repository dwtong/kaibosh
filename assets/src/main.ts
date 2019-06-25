import App from "@/App.vue";
import "@/assets/scss/app.scss";
import "@/class-component-hooks";
import Router from "@/router";
import Store from "@/store";

import Buefy from "buefy";
import VeeValidate from "vee-validate";
import Vue from "vue";

Vue.use(VeeValidate, {
  events: ""
});

Vue.use(Buefy, {
  defaultIconPack: "fas",
  defaultDateFormatter(date: Date) {
    return date.toLocaleDateString("en-GB");
  }
});

Vue.config.productionTip = false;

new Vue({
  render: h => h(App),
  router: Router,
  store: Store
}).$mount("#app");
