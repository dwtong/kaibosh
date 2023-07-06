import { ref } from 'vue'
import { defineStore } from 'pinia'
import { signIn, type LoginParams, signOut } from '@/api/auth'
import { authTokenIsPresent } from '@/utils/local-storage'

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(authTokenIsPresent())

  async function login(params: LoginParams): Promise<void> {
    if (await signIn(params)) {
      isAuthenticated.value = true
    }
  }

  async function logout(): Promise<void> {
    await signOut()
    isAuthenticated.value = false
  }

  return { login, logout, isAuthenticated }
})
