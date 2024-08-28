<script setup lang="ts">
import { useUserStore } from "@/stores/user"
import PasswordResetForm from "@/components/users/PasswordResetForm.vue"
import NotificationSettings from "@/components/users/NotificationSettings.vue"
import CreateUserForm from "@/components/users/CreateUserForm.vue"
import { putUser } from "@/api/users"
import { toast } from "@/utils/toast"

const userStore = useUserStore()
userStore.fetchUsers()

async function updatePassword(password: string) {
  await putUser({ password })
  toast({ message: "Password updated." })
}
</script>

<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <div class="box">
        <h1 class="title">Signup Notifications</h1>
        <NotificationSettings />
      </div>

      <div class="box">
        <PasswordResetForm :on-submit="updatePassword" />
      </div>

      <div class="box">
        <h1 class="title">Users</h1>
        <div v-for="user in userStore.users" :key="user.email">
          {{ user.email }}
        </div>
      </div>

      <div class="box">
        <h1 class="title">Add New User</h1>
        <CreateUserForm />
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.button {
  margin-top: 1rem;
}

form {
  margin-bottom: 3.5rem;
}
</style>
