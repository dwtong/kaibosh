<template>
  <button class="button is-info is-hidden-print" @click="print">
    {{ label }}
  </button>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class PrintButton extends Vue {
  @Prop({ default: "Print" }) readonly label!: string;

  print() {
    window.print();
  }
}
</script>
