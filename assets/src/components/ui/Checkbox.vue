<template>
  <div class="field">
    <b-checkbox :value="value" type="is-info" @input="$emit('input', $event)">{{ label }}</b-checkbox>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    value: {
      type: Boolean,
      required: true
    },
    label: {
      type: String,
      default: ""
    }
  },
  emits: ["input"]
});
</script>
