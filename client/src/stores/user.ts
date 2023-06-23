import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import { signIn, type LoginCreds } from '@/api/auth'

export const useUserStore = defineStore('user', () => {
  const isAuthenticated = ref(false)

  async function login(params: LoginCreds) {
    const response = await signIn(params);
    if (response) {
      isAuthenticated.value = true
    }
  }

  return { login, isAuthenticated }
})

  // @Action
  // async login(params: ILoginCreds) {
  //   const response = await AuthService.signIn(params);
  //   if (response) {
  //     this.context.commit("setAuthenticated", true);
  //   }
  // }

