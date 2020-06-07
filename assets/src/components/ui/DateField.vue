<template>
  <b-field :label="label">
    <b-datepicker
      placeholder="Click to select..."
      :value="value"
      @input="$emit('input', $event)"
      icon-pack="fas"
      :name="name"
      :disabled="disabled"
    />
  </b-field>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";

@Component
export default class DateField extends Vue {
  @Prop() readonly value!: string;
  @Prop({ default: "" }) readonly name!: string;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;

  get label() {
    return this.name.replace(/-/g, " ");
  }
}
</script>
