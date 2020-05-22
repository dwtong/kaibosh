<template>
  <div class="field">
    <b-checkbox :value="value" @input="$emit('input', $event)" type="is-info">{{ label }}</b-checkbox>
  </div>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Vue from "vue";

@Component
export default class Checkbox extends Vue {
  @Prop() readonly value!: boolean;
  @Prop({ default: "" }) readonly label!: string;
}
</script>
