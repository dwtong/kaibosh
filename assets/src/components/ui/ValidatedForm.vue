<template>
  <ValidationObserver v-slot="{ handleSubmit, valid }" tag="div">
    <form class="form" @submit.prevent="handleSubmit(submit)">
      <slot :valid="valid"></slot>
    </form>
  </ValidationObserver>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Emit } from "vue-property-decorator";
import { ValidationObserver } from "vee-validate";

@Component({ components: { ValidationObserver } })
export default class ValidatedForm extends Vue {
  @Emit()
  submit(event: Event) {
    return event;
  }
}
</script>
