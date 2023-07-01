<script setup lang="ts">
const props = defineProps<{ isActive: boolean }>()
</script>

<template>
  <div class="loader-wrapper" :class="{ 'is-active': props.isActive }">
    <div class="loader is-loading"></div>
  </div>
</template>

<style lang="scss" scoped>
.loader-wrapper {
  background: #fff;
  opacity: 0;
  z-index: -1;
  transition: opacity 0.3s;
  display: none;
  justify-content: center;
  align-items: center;
  border-radius: 6px;

  .loader {
    height: 40px;
    width: 40px;
  }

  &.is-active {
    display: flex;
    opacity: 1;
    z-index: 1;
  }
}

.is-loading {
  position: relative;
}
</style>
