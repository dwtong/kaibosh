<script setup lang="ts">
import { RouterView } from "vue-router"
import { computed } from "vue"
import NavBar from "./components/ui/NavBar.vue"
import { useRoute } from "vue-router"
import { useAuthStore } from "./stores/auth"
import LoadingSpinner from "./components/ui/LoadingSpinner.vue"
import { useAppStore } from "./stores/app"

const route = useRoute()
const authStore = useAuthStore()
const appStore = useAppStore()

const showNav = computed(() => {
  const isPublicRoute = route.matched.every((r) => r.meta.public)
  return !isPublicRoute && authStore.isAuthenticated
})
</script>

<template>
  <div v-if="showNav" class="sidenav is-hidden-print">
    <NavBar />
  </div>
  <div class="main" :class="{ 'with-nav': showNav }">
    <LoadingSpinner :is-active="appStore.isLoading" :is-fullscreen="true" />
    <section class="section">
      <div class="container is-fluid">
        <RouterView :key="route.fullPath" />
      </div>
    </section>
  </div>
</template>

<style lang="scss" scoped>
.container {
  @media print {
    padding-left: 0;
    padding-right: 0;
  }
}

.section {
  @media print {
    padding: 0 !important;
  }
}

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

.section {
  padding: 3rem 1.3rem;
}
</style>
