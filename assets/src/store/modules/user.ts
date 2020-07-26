import Store from "@/store";
import { Action, getModule, Module, Mutation, VuexModule } from "vuex-module-decorators";
import auth from "@/helpers/auth";
import AuthService from "@/services/auth-service";
import UserService from "@/services/user-service";
import { ILoginCreds, IUser } from "@/types";
import Router from "@/router";

@Module({ name: "user", store: Store, dynamic: true })
class User extends VuexModule {
  isAuthenticated: boolean = auth.authTokenIsPresent();
  passwordUpdated = false;
  users: IUser[] = [];

  get usersEmails() {
    return this.users.map(u => u.email);
  }

  @Action
  async login(params: ILoginCreds) {
    const response = await AuthService.signIn(params);
    if (response) {
      this.context.commit("setAuthenticated", true);
    }
  }

  @Action
  async createUser(email: string) {
    await UserService.createUser(email);
  }

  @Action
  async fetchUsers() {
    const users = await UserService.get();
    this.context.commit("setUsers", users);
  }

  @Action
  async resetPassword(email: string) {
    this.context.commit("setPasswordUpdated", false);
    const response = await AuthService.resetPassword(email);
    if (response) {
      this.context.commit("setPasswordUpdated", true);
    }
  }

  @Action
  async updatePassword(password: string) {
    this.context.commit("setPasswordUpdated", false);
    const response = await AuthService.changePassword(password, password);
    if (response) {
      this.context.commit("setPasswordUpdated", true);
    }
  }

  @Action
  async logout() {
    await AuthService.signOut();
    auth.deleteAuthToken();
    this.context.commit("setAuthenticated", false);
    Router.push("/login");
  }

  @Mutation
  setAuthenticated(isAuthenticated: boolean) {
    this.isAuthenticated = isAuthenticated;
  }

  @Mutation
  setUsers(users: IUser[]) {
    this.users = users;
  }

  @Mutation
  setPasswordUpdated(passwordUpdated: boolean) {
    this.passwordUpdated = passwordUpdated;
  }
}

export const UserModule = getModule(User);
