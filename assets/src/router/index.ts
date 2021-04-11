import VueRouter from "vue-router";
import routes from "./routes";

export default new VueRouter({
  base: process.env.BASE_URL,
  mode: "history",
  routes
});
