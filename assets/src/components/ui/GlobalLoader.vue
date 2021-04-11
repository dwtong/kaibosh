<template>
  <b-loading v-model="loading"></b-loading>
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
