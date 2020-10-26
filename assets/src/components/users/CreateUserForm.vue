<template>
  <ValidatedForm @submit="addUser">
    <ValidatedInput v-model="newUserEmail" label="email" type="email" :rules="{ email: true, excluded: usersEmails }" />
    <SubmitButton> Create User </SubmitButton>
  </ValidatedForm>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import SubmitButton from "@/components/ui/SubmitButton.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

@Component({ components: { SubmitButton, ValidatedInput, ValidatedForm } })
export default class PasswordField extends Vue {
  newUserEmail = "";

  get usersEmails() {
    return UserModule.usersEmails;
  }

  async addUser() {
    await UserModule.createUser(this.newUserEmail);
    await UserModule.resetPassword(this.newUserEmail);

    if (UserModule.passwordUpdated) {
      toast.success("User created.");
      UserModule.fetchUsers();
      this.newUserEmail = "";
    } else {
      toast.error("Failed to create user.");
    }
  }
}
</script>
