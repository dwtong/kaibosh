import { ref } from 'vue'
import { defineStore } from 'pinia'
import { getUsers, postUser } from '@/api/users'

export const useUserStore = defineStore('user', () => {
  const users = ref()

  async function createUser(email: string) {
    await postUser({ email })
  }

  async function fetchUsers() {
    await getUsers().then((data) => (users.value = data))
  }

  return { createUser, fetchUsers, users }
})
