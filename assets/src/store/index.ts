import Vue from "vue";
import Vuex from "vuex";
import LogRocket from "logrocket";
import createPlugin from "logrocket-vuex";
import { config } from "vuex-module-decorators";
config.rawError = true;
const plugins = [];

if (process.env.NODE_ENV === "production") {
  plugins.push(createPlugin(LogRocket));
}

export default Vuex.createStore({
  strict: process.env.NODE_ENV !== "production",
  plugins
});
