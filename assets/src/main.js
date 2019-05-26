import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import Buefy from "buefy";
import VeeValidate from "vee-validate";
import "./assets/scss/app.scss";

Vue.use(VeeValidate, {
  events: ""
});

Vue.use(Buefy, {
  defaultIconPack: "fas",
  defaultDateFormatter: date => {
    return date.toLocaleDateString("en-GB");
  }
});

Vue.config.productionTip = false;

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
