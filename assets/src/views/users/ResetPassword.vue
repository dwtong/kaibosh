<template>
  <div class="columns">
    <div class="column is-4 is-offset-4">
      <div class="box">
        <div class="logo">
          <img src="@/assets/images/kaibosh-green.png" alt />
        </div>
        <PasswordResetForm />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import PasswordResetForm from "@/components/users/PasswordResetForm.vue";

export default defineComponent({
  components: { PasswordResetForm }
});
</script>

<style lang="scss" scoped>
.box {
  padding-bottom: 4rem;
}

.button {
  margin-top: 1rem;
}

.forgotten-button {
  padding-top: 0.4rem;
  font-size: 0.9rem;
  color: white !important;
  &:hover {
    background-color: rgba(0, 0, 0, 0.1) !important;
  }
}

.field {
  padding-top: 1rem;
}

.label {
  color: #00bd00;
  font-weight: 700;
}

.logo {
  margin: 1rem auto 2rem auto;
  width: 300px;
  text-align: center;
  h1 {
    color: white;
    font-size: 2.5rem;
  }
}

.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
