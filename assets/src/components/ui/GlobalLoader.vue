<template>
  <b-loading :active.sync="loading"></b-loading>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import Bases from "@/store/modules/bases";

@Component
export default class GlobalLoader extends Vue {
  get loading() {
    return Bases.loading;
  }
}
</script>
