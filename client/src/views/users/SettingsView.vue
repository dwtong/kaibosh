<script setup lang="ts">
import { useUserStore } from "@/stores/user"
const users = useUserStore()
</script>

<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <div class="box">
        <h1 class="title">Signup Emails</h1>
        <NotificationSettings />
      </div>

      <div class="box">
        <PasswordResetForm />
      </div>

      <div class="box">
        <h1 class="title">Users</h1>
        <div v-for="user in users" :key="user.email">
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
