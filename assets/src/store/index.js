import Vue from "vue";
import Vuex from "vuex";
import recipients from "@/store/modules/recipients";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    recipients
  },
  strict: process.env.NODE_ENV !== "production"
});
