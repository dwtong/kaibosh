<template>
  <div id="app">
    <div>
      <div v-if="showNav" class="sidenav is-hidden-print">
        <NavBar />
      </div>
      <div class="main" :class="{ 'with-nav': showNav }">
        <section class="section">
          <div class="container is-fluid">
            <router-view :key="$route.fullPath"></router-view>
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import NavBar from "@/components/NavBar.vue";
import { UserModule } from "@/store/modules/user";

@Component({ components: { NavBar } })
export default class App extends Vue {
  get showNav() {
    return UserModule.isAuthenticated;
  }
}
</script>

<style lang="scss" scoped>
.main {
  background-color: $app-background;
  min-height: 100vh;
  overflow: hidden;

  &.with-nav {
    margin-left: $navbar-width;
    @media print {
      margin-left: 0;
    }
  }
}

.sidenav {
  height: 100%;
  width: $navbar-width;
  position: fixed;
  z-index: 1;
  top: 0;
  left: 0;
  overflow-x: hidden;
  padding: 1.3rem 0rem 2rem 1rem;
  background-color: $navbar-background;
}
</style>
