import { ref } from 'vue'
import { defineStore } from 'pinia'
import { getUsers, postUser } from '@/api/users'

export const useUserStore = defineStore('user', () => {
  const users = ref()

  async function createUser(email: string) {
    await postUser(email)
  }

  function fetchUsers() {
    getUsers().then(data => users.value = data)
  }

  fetchUsers()

  return { createUser, fetchUsers, users }
})

