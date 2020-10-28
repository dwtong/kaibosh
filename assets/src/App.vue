<template>
  <div id="app">
    <GlobalLoader />
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
import GlobalLoader from "@/components/ui/GlobalLoader.vue";
import NavBar from "@/components/ui/NavBar.vue";
import { UserModule } from "@/store/modules/user";

@Component({ components: { GlobalLoader, NavBar } })
export default class App extends Vue {
  get isAuthenticated() {
    return UserModule.isAuthenticated;
  }

  get showNav() {
    const isPublicRoute = this.$route.matched.every(r => r.meta.public)
    return !isPublicRoute && this.isAuthenticated;
  }
}
</script>

<style lang="scss" scoped>
.main {
  background-color: $app-background;
  min-height: 100vh;
  overflow: hidden;

  @media print {
    background-color: white;
  }

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
