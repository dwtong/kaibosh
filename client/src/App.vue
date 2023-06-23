<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import { ref } from "vue"
import GlobalLoader from '@/components/ui/GlobalLoader.vue'

const showNav = ref(true)
</script>

<template>
  <GlobalLoader />
  <div>
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

<style scoped>
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
