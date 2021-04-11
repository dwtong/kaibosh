<template>
  <b-tag rounded :type="labelType" size="is-medium">{{ statusLabel }}</b-tag>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    status: {
      type: String,
      required: true
    }
  },
  computed: {
    labelType(): string {
      return this.status == "on_hold" ? "is-warning" : "is-primary";
    },
    statusLabel(): string {
      return this.status.replace("_", " ");
    }
  }
});
</script>
