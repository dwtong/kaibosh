<script lang="ts" setup>
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'

const forgotten = false
const email = ref('')
const password = ref('')
const showError = ref(false)
const loading = ref(false)
const auth = useAuthStore()

const resetPassword = () => console.log('reset')
const toggleForgotten = () => console.log('forgotten')

async function login() {
  loading.value = true
  await auth.login({ email: email.value, password: password.value })
  loading.value = false

  if (!auth.isAuthenticated) {
    showError.value = true
  }
}
</script>

<template>
  <div class="columns">
    <div class="column is-4 is-offset-4">
      <div class="box">
        <div class="logo">
          <img src="@/assets/images/kaibosh.png" />
        </div>
        <form v-if="forgotten" class="login" @submit.prevent="resetPassword">
          <div class="field">
            <label class="label">Email</label>
            <p class="control has-icons-left">
              <input v-model="email" class="input" type="email" />
              <span class="icon is-small is-left">
                <i class="fa fa-envelope" />
              </span>
            </p>
          </div>
          <div v-if="showError" class="field">
            <p class="error-msg">Reset password failed. Please try again.</p>
          </div>
          <div class="field">
            <p class="control">
              <button class="button is-primary is-loading">
                Reset Password
              </button>
              <a
                class="button is-text forgotten-button"
                @click="toggleForgotten"
              >
                Login
              </a>
            </p>
          </div>
        </form>

        <form v-else class="login" @submit.prevent="login">
          <div class="field">
            <label class="label">Email</label>
            <p class="control has-icons-left">
              <input v-model="email" class="input" type="email" />
              <span class="icon is-small is-left">
                <i class="fa fa-envelope" />
              </span>
            </p>
          </div>
          <div class="field">
            <label class="label">Password</label>
            <p class="control has-icons-left">
              <input v-model="password" class="input" type="password" />
              <span class="icon is-small is-left">
                <i class="fa fa-lock" />
              </span>
            </p>
          </div>
          <div v-if="showError" class="field">
            <p class="error-msg">Login failed. Please try again.</p>
          </div>
          <div class="field">
            <p class="control">
              <button
                class="button is-primary"
                :class="{ 'is-loading': loading }"
              >
                Login
              </button>
              <a
                class="button is-text forgotten-button"
                @click="toggleForgotten"
              >
                Forgotten Password?
              </a>
            </p>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<!-- <script lang="ts"> -->
<!-- import Vue from "vue"; -->
<!-- import { Component } from "vue-property-decorator"; -->
<!-- import Router from "@/router"; -->
<!-- import { UserModule } from "@/store/modules/user"; -->
<!-- import toast from "@/helpers/toast"; -->
<!-- import App from "@/store/modules/app"; -->

<!-- @Component -->
<!-- export default class Login extends Vue { -->
<!--   email = ""; -->
<!--   password = ""; -->
<!--   showError = false; -->
<!--   forgotten = false; -->

<!--   async login() { -->
<!--     App.enableLoading(); -->
<!--     await UserModule.login({ email: this.email, password: this.password }); -->
<!--     if (UserModule.isAuthenticated) { -->
<!--       Router.push("/"); -->
<!--     } else { -->
<!--       this.showError = true; -->
<!--     } -->
<!--     App.disableLoading(); -->
<!--   } -->

<!--   async resetPassword() { -->
<!--     await UserModule.resetPassword(this.email); -->
<!--     if (UserModule.passwordUpdated) { -->
<!--       toast.success("Password reset email sent."); -->
<!--     } else { -->
<!--       this.showError = true; -->
<!--     } -->
<!--   } -->

<!--   toggleForgotten() { -->
<!--     this.showError = false; -->
<!--     this.forgotten = !this.forgotten; -->
<!--   } -->
<!-- } -->
<!-- </script> -->

<style lang="scss" scoped>
.box {
  background-color: $navbar-background;
}

.button {
  margin-top: 1rem;
}

.forgotten-button {
  padding-top: 0.4rem;
  font-size: 0.9rem;
  color: white !important;

  &:hover {
    background-color: rgba(0, 0, 0, 0.1) !important;
  }
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
