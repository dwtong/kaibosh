<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
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

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import CreateUserForm from "@/components/users/CreateUserForm.vue";
import PasswordResetForm from "@/components/users/PasswordResetForm.vue";
import { UserModule } from "@/store/modules/user";

@Component({ components: { CreateUserForm, PasswordResetForm } })
export default class Settings extends Vue {
  created() {
    UserModule.fetchUsers();
  }

  get users() {
    return UserModule.users;
  }
}
</script>

<style lang="scss" scoped>
.button {
  margin-top: 1rem;
}
form {
  margin-bottom: 3.5rem;
}
</style>
