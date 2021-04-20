<template>
  <!-- TODO add validation back into form -->
  <!-- <ValidationObserver v-slot="{ handleSubmit, valid }" tag="div"> -->
  <form class="form" @submit.prevent="handleSubmit(submit)">
    <!-- <slot :valid="valid"></slot> -->
    <slot />
  </form>
  <!-- </ValidationObserver> -->
</template>

<script lang="ts">
import { defineComponent } from "vue";
//import { ValidationObserver } from "vee-validate";

export default defineComponent({
  // components: {
  //  ValidationObserver
  //},
  emits: ["input"],
  methods: {
    submit(event: Event) {
      return this.$emit("input", event);
    }
  }
});
</script>
