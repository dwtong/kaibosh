/* eslint-disable @typescript-eslint/no-explicit-any */

import CreateRecipient from "@/views/recipients/CreateRecipient.vue";
import Signup from "@/views/recipients/Signup.vue";
import UpdateRecipient from "@/views/recipients/UpdateRecipient.vue";
import ListRecipients from "@/views/recipients/ListRecipients.vue";
import ShowRecipient from "@/views/recipients/ShowRecipient.vue";

import ShowSession from "@/views/sessions/ShowSession.vue";
import ListSessions from "@/views/sessions/ListSessions.vue";
import PrintRecipientDescriptions from "@/views/sessions/PrintRecipientDescriptions.vue";

import Login from "@/views/users/Login.vue";
import ResetPassword from "@/views/users/ResetPassword.vue";
import Settings from "@/views/users/Settings.vue";

// import NotFound from "@/views/NotFound.vue";

import auth from "@/helpers/auth";
import { UserModule } from "@/store/modules/user";

const ifNotAuthenticated = (_to: any, _from: any, next: any) => {
  if (!UserModule.isAuthenticated) {
    next();
  } else {
    next("/recipients");
  }
};

const ifAuthenticated = (_to: any, _from: any, next: any) => {
  if (UserModule.isAuthenticated) {
    next();
  } else {
    next("/login");
  }
};

const saveResetParams = (_to: any, _from: any, next: any) => {
  auth.saveAuthTokenFromUrlParams();
  next();
};

export default [
  {
    path: "/login",
    component: Login,
    beforeEnter: ifNotAuthenticated
  },
  {
    path: "/signup",
    component: Signup,
    meta: { public: true }
  },
  {
    path: "/",
    beforeEnter: ifAuthenticated,
    redirect: "/sessions/week"
  },
  {
    path: "/recipients",
    component: ListRecipients,
    beforeEnter: ifAuthenticated,
    children: [
      {
        path: "new",
        component: CreateRecipient,
        beforeEnter: ifAuthenticated
      },
      {
        path: "update/:id",
        component: UpdateRecipient,
        beforeEnter: ifAuthenticated,
        props: true
      },
      {
        path: ":id",
        component: ShowRecipient,
        beforeEnter: ifAuthenticated,
        props: true
      }
    ]
  },
  {
    path: "/sessions/week",
    component: ListSessions,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/sessions/:id",
    component: ShowSession,
    beforeEnter: ifAuthenticated,
    props: true,
    children: [
      {
        path: "descriptions",
        component: PrintRecipientDescriptions,
        beforeEnter: ifAuthenticated,
        props: true
      }
    ]
  },
  {
    path: "/settings",
    component: Settings,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/reset_password",
    component: ResetPassword,
    beforeEnter: saveResetParams,
    props: true
  }

  // TODO: fix 404 page
  // {
  //   path: "/:pathMatch(.*)*",
  //   name: "not-found",
  //   component: NotFound
  // }
];
