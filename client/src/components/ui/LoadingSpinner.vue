<script setup lang="ts">
const props = defineProps<{
  isActive: boolean
  isFullscreen: boolean
}>()
</script>

<template>
  <div
    class="loader-wrapper"
    :class="{
      'is-active': props.isActive,
      'is-fullscreen': props.isFullscreen,
    }"
  >
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
    height: 100px;
    width: 100px;
  }

  &.is-active {
    display: flex;
    opacity: 1;
    z-index: 1;
  }

  &.is-fullscreen {
    position: absolute;
    height: 100%;
    width: 100%;
    background: rgb(255 255 255 / 40%);
    z-index: 2;
  }
}

.is-loading {
  position: relative;
}
</style>
