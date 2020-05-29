/* eslint-disable @typescript-eslint/no-explicit-any */

import auth from "@/helpers/auth";
import CreateRecipient from "@/views/CreateRecipient.vue";
import UpdateRecipient from "@/views/UpdateRecipient.vue";
import ListRecipients from "@/views/ListRecipients.vue";
import Login from "@/views/Login.vue";
import NotFound from "@/views/NotFound.vue";
import ShowRecipient from "@/views/ShowRecipient.vue";
import SessionAllocations from "@/views/SessionAllocations.vue";
import SessionRecipientDescriptions from "@/views/SessionRecipientDescriptions.vue";
import SessionsByWeek from "@/views/SessionsByWeek.vue";
import ResetPassword from "@/views/ResetPassword.vue";
import UserSettings from "@/views/UserSettings.vue";
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
    component: SessionsByWeek,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/sessions/:id",
    component: SessionAllocations,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/sessions/:id/descriptions",
    component: SessionRecipientDescriptions,
    beforeEnter: ifAuthenticated,
    props: true
  },
  {
    path: "/settings",
    component: UserSettings,
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
