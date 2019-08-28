<template>
  <aside class="menu">
    <div class="logo">
      <img src="@/assets/images/kaibosh.png" alt />
    </div>

    <p class="menu-label">Food Recipients</p>
    <ul class="menu-list">
      <li>
        <router-link
          v-on:click.native="resetRecipientFilters"
          to="/recipients"
          active-class="is-active"
          exact
          >View Recipients</router-link
        >
      </li>
      <li>
        <router-link to="/recipients/new" active-class="is-active" exact
          >Add New Recipient</router-link
        >
      </li>
    </ul>

    <p class="menu-label">Schedule</p>
    <ul class="menu-list">
      <li>
        <a>View Schedule</a>
      </li>
    </ul>
  </aside>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import { AllRecipientsModule } from "@/store/modules/all-recipients";

@Component
export default class NavBar extends Vue {
  resetRecipientFilters() {
    AllRecipientsModule.resetFilters();
  }
}
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
      color: $text;
    }

    &.is-active {
      background-color: $background;
      color: $text;
      border-radius: 1rem 0 0 1rem;
      &:hover {
        border-radius: 1rem 0 0 1rem;
        background-color: $primary;
        color: $text;
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
