<template>
  <aside class="menu">
    <div class="logo">
      <img src="@/assets/images/kaibosh.png" alt />
    </div>

    <p class="menu-label">Schedule</p>
    <ul class="menu-list">
      <li>
        <router-link to="/sessions/week" active-class="is-active" exact> Sessions By Week </router-link>
      </li>
    </ul>

    <p class="menu-label">Food Recipients</p>
    <ul class="menu-list">
      <li>
        <router-link to="/recipients" active-class="is-active" exact @click="resetRecipientNameFilter">
          View Recipients
        </router-link>
      </li>
      <li>
        <router-link to="/recipients/new" active-class="is-active" exact> Add New Recipient </router-link>
      </li>
    </ul>

    <p class="menu-label">Settings</p>
    <ul class="menu-list">
      <li>
        <router-link to="/settings" active-class="is-active"> User Settings </router-link>
      </li>
      <li>
        <a @click="logout">Logout</a>
      </li>
    </ul>
  </aside>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AllRecipients from "@/store/modules/all-recipients";
import { UserModule } from "@/store/modules/user";

export default defineComponent({
  methods: {
    resetRecipientNameFilter() {
      AllRecipients.updateNameFilter("");
    },

    async logout() {
      await UserModule.logout();
    }
  }
});
</script>

<style lang="scss" scoped>
.logo {
  margin: 1rem 1rem 2.5rem 2rem;
  width: 150px;
  text-align: center;
  h1 {
    color: white;
    font-size: 2.5rem;
  }
}

.menu-label {
  margin-top: 2.5rem !important;
  margin-left: 2.5rem;
  color: $primary;
  font-weight: 700;
}

.menu-list {
  a {
    &:hover {
      border-radius: 1rem 0 0 1rem;
      background-color: $primary;
      color: white;
    }

    &.is-active {
      background-color: $background;
      color: $text;
      border-radius: 1rem 0 0 1rem;
      &:hover {
        border-radius: 1rem 0 0 1rem;
        background-color: $primary;
        color: white;
      }
    }
    color: white;
    margin-left: 1rem;
    padding-left: 1.5rem;
    padding-top: 0.6rem;
    padding-bottom: 0.6rem;
    margin-top: 0.6rem;
    margin-bottom: 0.6rem;
  }
}
</style>
