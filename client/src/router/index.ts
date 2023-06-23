import { createRouter, createWebHistory } from 'vue-router'
import LoginView from "@/views/users/LoginView.vue"

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [{
    path: "/",
    // beforeEnter: ifAuthenticated,
    // redirect: "/sessions/week"
    redirect: "/login"
  },
  {
    path: "/login",
    component: LoginView,
    // beforeEnter: ifNotAuthenticated
  }]
})

export default router
