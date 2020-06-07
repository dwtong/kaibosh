<template>
  <button type="submit" :class="{ 'is-loading': isSubmitting }" class="button is-primary">
    <slot>Submit</slot>
  </button>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class ValidatedSelect extends Vue {
  @Prop({ default: false }) readonly isSubmitting!: boolean;
}
</script>
