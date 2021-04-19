import { createRouter, createWebHistory } from "vue-router";
import routes from "./routes";

const base = process.env.BASE_URL;

export default createRouter({
  history: createWebHistory(base),
  routes
});
