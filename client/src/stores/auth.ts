import { ref } from 'vue'
import { defineStore } from 'pinia'
import { signIn, type LoginCreds } from '@/api/auth'
import { authTokenIsPresent } from '@/utils/local-storage'

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(authTokenIsPresent())

  async function login(params: LoginCreds) {
    const response = await signIn(params)
    if (response) {
      isAuthenticated.value = true
    }
  }

  return { login, isAuthenticated }
})
