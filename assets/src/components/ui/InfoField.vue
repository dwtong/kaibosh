<template>
  <div class="field">
    <label class="label">{{ $attrs.label }}</label>
    <div class="control">
      <p class="text">
        <slot></slot>
      </p>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
export default defineComponent({});
</script>

<style lang="scss" scoped>
.field {
  margin-top: 1.5rem;
  .text {
    margin-left: 0.2rem;
  }
}
</style>
