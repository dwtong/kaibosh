<template>
  <button class="button is-info is-hidden-print" @click="print">
    {{ label }}
  </button>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  props: {
    label: {
      type: String,
      default: "Print"
    }
  },
  methods: {
    print() {
      window.print();
    }
  }
});
</script>
