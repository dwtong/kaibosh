<template>
  <div class="field">
    <label class="label">{{ label }}</label>
    <transition name="fade">
      <div v-if="value" class="control">
        <p class="text">{{ value }}</p>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  computed: {
    show: () => true
  },
  props: ["label", "value"]
};
</script>

<style lang="scss" scoped>
.field {
  margin-top: 1.5rem;
  .text {
    margin-left: 0.2rem;
  }
}
</style>
