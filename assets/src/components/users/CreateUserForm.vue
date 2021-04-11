<template>
  <ValidatedForm @submit="addUser">
    <ValidatedInput v-model="newUserEmail" label="email" type="email" :rules="{ email: true, excluded: usersEmails }" />
    <SubmitButton> Create User </SubmitButton>
  </ValidatedForm>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import SubmitButton from "@/components/ui/SubmitButton.vue";
import ValidatedInput from "@/components/ui/ValidatedInput.vue";
import ValidatedForm from "@/components/ui/ValidatedForm.vue";
import { UserModule } from "@/store/modules/user";
import toast from "@/helpers/toast";

export default defineComponent({
  components: {
    SubmitButton,
    ValidatedInput,
    ValidatedForm
  },
  props: {},
  data() {
    return {
      newUserEmail: ""
    };
  },
  computed: {
    usersEmails() {
      return UserModule.usersEmails;
    }
  },
  methods: {
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
});
</script>
