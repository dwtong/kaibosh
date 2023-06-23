import { createRouter, createWebHistory } from 'vue-router'
import LoginView from "@/views/users/LoginView.vue"
import ListSessionsView from "@/views/sessions/ListSessionsView.vue"
import { useUserStore } from '@/stores/user'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [{
    path: "/",
    redirect: "/sessions/week"
  },
  {
    path: "/login",
    component: LoginView,
    meta: { public: true }
  },
  // {
  //   path: "/signup",
  //   component: Signup,
  //   meta: { public: true }
  // },
  // {
  //   path: "/recipients",
  //   component: ListRecipients,
  // },
  // {
  //   path: "/recipients/new",
  //   component: CreateRecipient,
  // },
  // {
  //   path: "/recipients/:id",
  //   component: ShowRecipient,
  //   props: true
  // },
  // {
  //   path: "/recipients/update/:id",
  //   component: UpdateRecipient,
  //   props: true
  // },
  {
    path: "/sessions/week",
    component: ListSessionsView,
    props: true
  },
    // {
    //   path: "/sessions/:id",
    //   component: ShowSession,
    //   props: true
    // },
    // {
    //   path: "/sessions/:id/descriptions",
    //   component: PrintRecipientDescriptions,
    //   props: true
    // },
    // {
    //   path: "/settings",
    //   component: Settings,
    //   props: true
    // },
    // {
    //   path: "/reset_password",
    //   component: ResetPassword,
    //   beforeEnter: saveResetParams,
    //   props: true
    // },
    // {
    //   component: NotFound,
    //   path: "*"
    // }
  ]
})

router.beforeEach((to) => {
  const user = useUserStore()

  if (!to.meta.public && !user.isAuthenticated) {
    console.log('meta', to.meta.public)
    console.log('auth', user.isAuthenticated)
    return {
      path: '/login',
      query: { redirect: to.fullPath }
    }
  }

})

export default router

// import CreateRecipient from "@/views/recipients/CreateRecipient.vue";
// import Signup from "@/views/recipients/Signup.vue";
// import UpdateRecipient from "@/views/recipients/UpdateRecipient.vue";
// import ListRecipients from "@/views/recipients/ListRecipients.vue";
// import ShowRecipient from "@/views/recipients/ShowRecipient.vue";

// import ShowSession from "@/views/sessions/ShowSession.vue";
// import ListSessions from "@/views/sessions/ListSessions.vue";
// import PrintRecipientDescriptions from "@/views/sessions/PrintRecipientDescriptions.vue";

// import Login from "@/views/users/Login.vue";
// import ResetPassword from "@/views/users/ResetPassword.vue";
// import Settings from "@/views/users/Settings.vue";

// import NotFound from "@/views/NotFound.vue";

// import auth from "@/helpers/auth";
// import { UserModule } from "@/store/modules/user";
// import { Route } from "vue-router";

// const ifNotAuthenticated = (to: Route, from: Route, next: any) => {
//   if (!UserModule.isAuthenticated) {
//     next();
//   } else {
//     next("/recipients");
//   }
// };


//   if (UserModule.isAuthenticated) {
//     next();
//   } else {
//     next("/login");
//   }
// };

// const saveResetParams = (to: Route, from: Route, next: any) => {
//   auth.saveAuthTokenFromUrlParams();
//   next();
// };

// export default [
// ];
