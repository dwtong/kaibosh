<script setup lang="ts">
import { updatePassword } from "@/api/auth"
import PasswordResetForm from "@/components/users/PasswordResetForm.vue"
import { useAuthStore } from "@/stores/auth"
import { toast } from "@/utils/toast"
import { useRoute } from "vue-router"

const route = useRoute()
const auth = useAuthStore()

async function onSubmit(password: string) {
  const token = route.query?.password_reset_token?.toString() ?? ""
  const { email } = await updatePassword({ token, password })
  toast({ message: "Password updated." })
  await auth.login({ email, password })
}
</script>

<template>
  <div class="columns">
    <div class="column is-4 is-offset-4">
      <div class="box">
        <div class="logo">
          <img src="@/assets/images/kaibosh-green.png" alt="logo" />
        </div>
        <PasswordResetForm :on-submit="onSubmit" />
      </div>
    </div>
  </div>
</template>

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

.logo {
  margin: 1rem auto 2rem auto;
  width: 300px;
  text-align: center;
  h1 {
    color: white;
    font-size: 2.5rem;
  }
}
</style>
