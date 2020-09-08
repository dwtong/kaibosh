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

import NotFound from "@/views/NotFound.vue";

import auth from "@/helpers/auth";
import { UserModule } from "@/store/modules/user";
import { Route } from "vue-router";

const ifNotAuthenticated = (to: Route, from: Route, next: any) => {
  if (!UserModule.isAuthenticated) {
    next();
  } else {
    next("/recipients");
  }
};

const ifAuthenticated = (to: Route, from: Route, next: any) => {
  if (UserModule.isAuthenticated) {
    next();
  } else {
    next("/login");
  }
};

const saveResetParams = (to: Route, from: Route, next: any) => {
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
    component: Signup
  },
  {
    path: "/",
    beforeEnter: ifAuthenticated,
    redirect: "/sessions/week"
  },
  {
    path: "/recipients",
    component: ListRecipients,
    beforeEnter: ifAuthenticated
  },
  {
    path: "/recipients/new",
    component: CreateRecipient,
    beforeEnter: ifAuthenticated
  },
  {
    path: "/recipients/:id",
    component: ShowRecipient,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/recipients/update/:id",
    component: UpdateRecipient,
    beforeEnter: ifAuthenticated,
    props: true
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
    props: true
  },
  {
    path: "/sessions/:id/descriptions",
    component: PrintRecipientDescriptions,
    beforeEnter: ifAuthenticated,
    props: true
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
  },
  {
    component: NotFound,
    path: "*"
  }
];
