<template>
  <b-tag rounded :type="labelType" size="is-medium">{{ status ? status : "active" }}</b-tag>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class HoldStatusTag extends Vue {
  @Prop() readonly status!: string;

  get labelType() {
    if (this.status) {
      return "is-warning";
    } else {
      return "is-primary";
    }
  }
}
</script>
