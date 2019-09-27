<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <div class="box">
        <form @submit.prevent>
          <h1 class="title">Update Password</h1>

          <InputField
            name="password"
            v-model="password"
            type="password"
            :validation="{ required: true, min: 8 }"
          />
          <InputField
            name="confirm-password"
            v-model="passwordConfirmation"
            type="password"
            :validation="{ required: true, min: 8, is: password }"
          />
          <b-button
            @click="updatePassword"
            :loading="updatingPassword"
            type="submit"
            class="button is-primary is-pulled-right"
          >
            Update Password
          </b-button>
        </form>
      </div>

      <div class="box">
        <h1 class="title">Organisation Data Setup</h1>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import InputField from "@/components/form/InputField.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

@Component({ components: { InputField }, $_veeValidate: { validator: "new" } })
export default class UserSettings extends Vue {
  password = "";
  passwordConfirmation = "";
  error!: string;
  updatingPassword = false;

  async updatePassword() {
    this.updatingPassword = true;
    const formIsValid = await this.$validator.validateAll();

    if (formIsValid) {
      await UserModule.updatePassword(this.password);

      if (UserModule.passwordUpdated) {
        toast.success("Password updated.");
        this.$router.push("/");
      } else {
        toast.error("Failed to update password.");
      }
    } else {
      toast.error("Failed to update password.", true);
    }

    this.updatingPassword = false;
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
