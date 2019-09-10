<template>
  <div class="columns">
    <div class="column is-4 is-offset-4">
      <div class="box">
        <div class="logo">
          <img src="@/assets/images/kaibosh.png" alt />
        </div>
        <form class="login" @submit.prevent="login">
          <div class="field">
            <label class="label">Email</label>
            <p class="control has-icons-left">
              <input v-model="email" class="input" type="email" />
              <span class="icon is-small is-left">
                <i class="fa fa-envelope"></i>
              </span>
            </p>
          </div>
          <div class="field">
            <label class="label">Password</label>
            <p class="control has-icons-left">
              <input v-model="password" class="input" type="password" />
              <span class="icon is-small is-left">
                <i class="fa fa-lock"></i>
              </span>
            </p>
          </div>
          <div v-if="showError" class="field">
            <p class="error-msg">
              Login failed. Please try again.
            </p>
          </div>
          <div class="field">
            <p class="control">
              <button class="button is-primary">
                Login
              </button>
            </p>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import AuthService from "@/services/auth-service";
import Router from "@/router";
import { UserModule } from "../store/modules/user";

@Component
export default class Login extends Vue {
  email: string = "";
  password: string = "";
  showError = false;

  async login() {
    await UserModule.login({ email: this.email, password: this.password });
    if (UserModule.isAuthenticated) {
      Router.push("/");
    } else {
      this.showError = true;
    }
  }
}
</script>

<style lang="scss" scoped>
.box {
  background-color: $navbar-background;
}

.button {
  margin-top: 1rem;
}

.field {
  padding-top: 1rem;
}

.label {
  color: #00bd00;
  font-weight: 700;
}

.logo {
  margin: 1rem auto 2rem auto;
  width: 250px;
  text-align: center;
  h1 {
    color: white;
    font-size: 2.5rem;
  }
}

.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
