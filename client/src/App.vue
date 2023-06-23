<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { computed } from "vue"
import GlobalLoader from '@/components/ui/GlobalLoader.vue'

const showNav = computed(() => {
  // const isPublicRoute = this.$route.matched.every(r => r.meta.public);
  // return !isPublicRoute && this.isAuthenticated;
  return false
})
</script>

<template>
  <GlobalLoader />
  <div v-if="showNav" class="sidenav is-hidden-print">
    <NavBar />
  </div>
  <div class="main" :class="{ 'with-nav': showNav }">
    <section class="section">
      <div class="container is-fluid">
        <!-- <RouterView :key="$route.fullPath"></RouterView> -->
        <RouterView></RouterView>
      </div>
    </section>
  </div>
  <!-- <header> -->
  <!--   <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" /> -->

  <!--   <div class="wrapper"> -->
  <!--     <HelloWorld msg="You dud it!" /> -->

  <!--     <nav> -->
  <!--       <RouterLink to="/">Home</RouterLink> -->
  <!--       <RouterLink to="/about">About</RouterLink> -->
  <!--     </nav> -->
  <!--   </div> -->
  <!-- </header> -->

  <!-- <RouterView /> -->
</template>

<style lang="scss" scoped>
.main {
  background-color: $app-background;
  min-height: 100vh;
  min-width: 100vw;
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
