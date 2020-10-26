<template>
  <b-loading v-model="loading"></b-loading>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import App from "@/store/modules/app";

@Component
export default class GlobalLoader extends Vue {
  get loading() {
    return App.loading;
  }
}
</script>
