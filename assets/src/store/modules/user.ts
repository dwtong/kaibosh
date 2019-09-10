import Store from "@/store";
import {
  Action,
  getModule,
  Module,
  Mutation,
  VuexModule
} from "vuex-module-decorators";
import auth from "@/helpers/auth";
import AuthService from "@/services/auth-service";
import { ILoginCreds } from "@/types";

@Module({ name: "user", store: Store, dynamic: true })
class User extends VuexModule {
  isAuthenticated: boolean = auth.authTokenIsPresent();

  @Action
  async login(params: ILoginCreds) {
    const response = await AuthService.signIn(params);
    if (response) {
      this.context.commit("setAuthenticated", true);
    }
  }

  @Action
  async logout() {
    await AuthService.signOut();
    auth.deleteAuthToken();
    this.context.commit("setAuthenticated", false);
  }

  @Mutation
  setAuthenticated(isAuthenticated: boolean) {
    this.isAuthenticated = isAuthenticated;
  }
}

export const UserModule = getModule(User);
