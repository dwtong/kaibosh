<template>
  <div>
    <div v-if="withLabel" class="field">
      <label class="label">Status</label>
      <transition name="fade">
        <b-tag rounded :type="type" :size="size">{{ label }}</b-tag>
      </transition>
    </div>
    <b-tag v-else rounded :size="size" :type="type">{{ label }}</b-tag>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IStatusLabelGroup } from "@/types";

@Component
export default class RecipientStatusTag extends Vue {
  @Prop({ default: "" }) readonly status!: string;
  @Prop({ default: "is-small" }) readonly size!: string;
  @Prop({ default: false }) readonly withLabel!: boolean;

  get label() {
    return this.status?.replace("_", " ");
  }

  get type(): string {
    const types: IStatusLabelGroup = {
      on_hold: "is-warning",
      active: "is-primary",
      archived: "is-gray-darker",
      pending: "is-info"
    };

    return this.status ? types[this.status] : "is-gray-darker";
  }
}
</script>
