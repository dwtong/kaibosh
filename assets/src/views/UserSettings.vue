<template>
  <div class="columns">
    <div class="column is-half is-offset-one-quarter">
      <div class="box">
        <PasswordResetForm />
      </div>

      <div class="box">
        <h1 class="title">Add New User</h1>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import PasswordResetForm from "@/components/PasswordResetForm.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

@Component({
  components: { PasswordResetForm },
  $_veeValidate: { validator: "new" }
})
export default class UserSettings extends Vue {}
</script>

<style lang="scss" scoped>
.button {
  margin-top: 1rem;
}
form {
  margin-bottom: 3.5rem;
}
</style>
