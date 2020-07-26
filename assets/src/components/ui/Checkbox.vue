<template>
  <div class="field">
    <b-checkbox :value="value" type="is-info" @input="$emit('input', $event)">{{ label }}</b-checkbox>
  </div>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";

@Component
export default class Checkbox extends Vue {
  @Prop() readonly value!: boolean;
  @Prop({ default: "" }) readonly label!: string;
}
</script>
