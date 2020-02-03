<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <transition name="fade">
      <div v-if="value && !isLoading" class="control">
        <p class="text">{{ value }}</p>
      </div>
    </transition>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class InfoField extends Vue {
  @Prop({ default: "" }) readonly label!: string;
  @Prop({ default: "" }) readonly value!: string;
  @Prop({ default: false }) readonly isLoading!: boolean;
}
</script>

<style lang="scss" scoped>
.field {
  margin-top: 1.5rem;
  .text {
    margin-left: 0.2rem;
  }
}
</style>
