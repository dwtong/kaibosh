<template>
  <b-tag rounded :type="type">{{ label }}</b-tag>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IStatusLabelGroup } from "@/types";

@Component
export default class RecipientStatusTag extends Vue {
  @Prop({ default: "" }) readonly status!: string;

  get label() {
    return this.status.replace("_", " ");
  }

  get type(): string {
    const types: IStatusLabelGroup = {
      active: "is-primary",
      on_hold: "is-warning",
      archived: "is-gray-darker",
      pending: "is-info"
    };

    return types[this.status];
  }
}
</script>
