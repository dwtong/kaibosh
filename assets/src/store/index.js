import Vue from "vue";
import Vuex from "vuex";
import bases from "@/store/modules/bases";
import recipients from "@/store/modules/recipients";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    bases,
    recipients
  },
  strict: process.env.NODE_ENV !== "production"
});
