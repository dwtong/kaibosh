<template>
  <ValidatedForm @submit="updatePassword">
    <h1 class="title">Update Password</h1>
    <PasswordField v-model="password" with-confirmation="true" />
    <SubmitButton :is-submitting="updatingPassword" />
  </ValidatedForm>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import PasswordField from "@/components/ui/PasswordField.vue";
import SubmitButton from "@/components/ui/SubmitButton.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

@Component({ components: { PasswordField, SubmitButton, ValidatedForm } })
export default class PasswordResetForm extends Vue {
  password = "";
  updatingPassword = false;

  async updatePassword() {
    this.updatingPassword = true;

    const token = this.$route.query?.password_reset_token.toString()
    await UserModule.updatePassword({password: this.password, token});

    if (UserModule.passwordUpdated) {
      toast.success("Password updated.");

      if (!UserModule.isAuthenticated) {
        this.$router.push("/login");
      }
    } else {
      toast.error("Failed to update password.");
    }

    this.updatingPassword = false;
  }
}
</script>
