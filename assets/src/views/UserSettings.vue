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
        <form @submit.prevent="addUser">
          <InputField
            name="email"
            v-model="newUserEmail"
            type="email"
            :validation="{ email: true }"
          />
          <button type="submit" class="button is-primary is-pulled-right">
            Create User
          </button>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import PasswordResetForm from "@/components/PasswordResetForm.vue";
import InputField from "@/components/form/InputField.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

@Component({
  components: { PasswordResetForm, InputField },
  $_veeValidate: { validator: "new" }
})
export default class UserSettings extends Vue {
  newUserEmail: string = "";

  created() {
    UserModule.fetchUsers();
  }

  get users() {
    return UserModule.users;
  }

  async addUser() {
    await UserModule.createUser(this.newUserEmail);
    await UserModule.resetPassword(this.newUserEmail);

    if (UserModule.passwordUpdated) {
      toast.success("User created.");
    } else {
      toast.error("Failed to create user.");
    }
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
