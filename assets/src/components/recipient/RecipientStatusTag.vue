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
  @Prop({ default: false }) readonly isLoading!: boolean;

  get label() {
    if (!this.isLoading) {
      return this.status.replace("_", " ");
    } else {
      return "";
    }
  }

  get type(): string {
    const types: IStatusLabelGroup = {
      active: "is-primary",
      // eslint-disable-next-line @typescript-eslint/camelcase
      on_hold: "is-warning",
      archived: "is-gray-darker",
      pending: "is-info"
    };

    if (!this.isLoading) {
      return types[this.status];
    } else {
      return "is-gray-darker";
    }
  }
}
</script>
