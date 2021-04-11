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

<script lang="ts">
import { defineComponent } from "vue";
import CreateUserForm from "@/components/users/CreateUserForm.vue";
import NotificationSettings from "@/components/users/NotificationSettings.vue";
import PasswordResetForm from "@/components/users/PasswordResetForm.vue";
import { UserModule } from "@/store/modules/user";

export default defineComponent({
  components: {
    CreateUserForm,
    NotificationSettings,
    PasswordResetForm
  },
  setup() {
    UserModule.fetchUsers();
  },
  computed: {
    users() {
      return UserModule.users;
    }
  }
});
</script>

<style lang="scss" scoped>
.button {
  margin-top: 1rem;
}
form {
  margin-bottom: 3.5rem;
}
</style>
