<template>
  <button type="submit" :class="cssClass" class="button" :disabled="disabled">
    <slot>Submit</slot>
  </button>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class SubmitButton extends Vue {
  @Prop({ default: false }) readonly isSubmitting!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;
  @Prop({ default: "is-primary" }) readonly type!: string;

  get cssClass() {
    return { "is-loading": this.isSubmitting, [this.type]: true };
  }
}
</script>
