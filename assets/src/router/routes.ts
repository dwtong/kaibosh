import auth from "@/helpers/auth";
import CreateRecipient from "@/views/CreateRecipient.vue";
import UpdateRecipient from "@/views/UpdateRecipient.vue";
import ListRecipients from "@/views/ListRecipients.vue";
import Login from "@/views/Login.vue";
import NotFound from "@/views/NotFound.vue";
import ShowRecipient from "@/views/ShowRecipient.vue";
import ResetPassword from "@/views/ResetPassword.vue";
import UserSettings from "@/views/UserSettings.vue";
import { UserModule } from "@/store/modules/user";

const ifNotAuthenticated = (to: any, from: any, next: any) => {
  if (!UserModule.isAuthenticated) {
    next();
  } else {
    next("/recipients");
  }
};

const ifAuthenticated = (to: any, from: any, next: any) => {
  if (UserModule.isAuthenticated) {
    next();
  } else {
    next("/login");
  }
};

const saveResetParams = (to: any, from: any, next: any) => {
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
    redirect: "/recipients"
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
