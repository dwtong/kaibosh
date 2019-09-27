import Vue from "vue";
import Vuex from "vuex";
import LogRocket from "logrocket";
import createPlugin from "logrocket-vuex";
const plugins = [];

if (process.env.NODE_ENV === "production") {
  plugins.push(createPlugin(LogRocket));
}

Vue.use(Vuex);

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== "production",
  plugins
});
