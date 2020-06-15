<template>
  <b-field :label="label">
    <b-datepicker
      placeholder="Click to select..."
      :value="dateValue"
      icon-pack="fas"
      :name="name"
      :disabled="disabled"
      @input="$emit('input', $event)"
    />
  </b-field>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";

@Component
export default class DateField extends Vue {
  @Prop({ default: "" }) readonly value!: Date | string;
  @Prop({ default: "" }) readonly name!: string;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;

  get dateValue() {
    if (this.value === "") {
      return null;
    } else {
      return new Date(this.value);
    }
  }

  get label() {
    return this.name.replace(/-/g, " ");
  }
}
</script>
