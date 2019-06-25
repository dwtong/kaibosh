<template>
  <div id="app">
    <div class="sidenav">
      <NavBar />
    </div>
    <div class="main">
      <section class="section">
        <div class="container is-fluid">
          <router-view></router-view>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
import NavBar from "@/components/NavBar.vue";

export default {
  components: {
    NavBar
  }
};
</script>

<style lang="scss" scoped>
.main {
  margin-left: $navbar-width;
  background-color: $app-background;
  min-height: 100vh;
  overflow: hidden;
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
