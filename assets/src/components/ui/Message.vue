<template>
  <article class="message" :class="type">
    <div class="message-header">
      <p>{{ title }}</p>
      <button class="delete" aria-label="delete"></button>
    </div>
    <div class="message-body">
      <slot />
    </div>
  </article>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    title: {
      type: String,
      default: ""
    },
    type: {
      type: String,
      default: "is-info"
    }
  }
});
</script>
