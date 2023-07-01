import { ref } from 'vue'
import { defineStore } from 'pinia'
import { signIn, type LoginParams } from '@/api/auth'
import { authTokenIsPresent } from '@/utils/local-storage'

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(authTokenIsPresent())

  async function login(params: LoginParams) {
    const response = await signIn(params)
    if (response) {
      isAuthenticated.value = true
    }
  }

  return { login, isAuthenticated }
})
