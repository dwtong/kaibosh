import { ref } from 'vue'
import { defineStore } from 'pinia'
import { signIn, type LoginParams, signOut } from '@/api/auth'
import { authTokenIsPresent, deleteAuthToken } from '@/utils/local-storage'
import { useRouter } from 'vue-router'

export const useAuthStore = defineStore('auth', () => {
  const isAuthenticated = ref(authTokenIsPresent())
  const router = useRouter()

  async function login(params: LoginParams): Promise<void> {
    if (await signIn(params)) {
      isAuthenticated.value = true
      router.push('/')
    }
  }

  async function logout(): Promise<void> {
    await signOut()
    deleteAuthToken()
    isAuthenticated.value = false
    router.push('/login')
  }

  return { login, logout, isAuthenticated }
})
