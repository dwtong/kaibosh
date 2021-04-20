<template>
  <div class="loader-wrapper">
    <div class="loader" :class="{ 'is-loading': loading }"></div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import App from "@/store/modules/app";

export default defineComponent({
  computed: {
    loading() {
      return App.loading;
    }
  }
});
</script>
