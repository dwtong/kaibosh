<template>
  <button type="submit" :class="cssClass" class="button" :disabled="disabled">
    <slot>Submit</slot>
  </button>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    isSubmitting: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    },
    type: {
      type: String,
      default: "is-primary"
    }
  },
  computed: {
    cssClass(): { [key: string]: boolean } {
      return { "is-loading": this.isSubmitting, [this.type]: true };
    }
  }
});
</script>
