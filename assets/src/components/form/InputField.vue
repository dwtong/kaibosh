<template>
  <b-field :label="label">
    <b-input
      :value="value"
      @input="$emit('input', $event)"
      :data-vv-as="label"
      :name="name"
      v-validate="{ required: required }"
    />
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop, PropSync } from "vue-property-decorator";
import Vue from "vue";

@Component
export default class InputField extends Vue {
  @Prop() readonly value: any;
  @Prop({ default: "" }) readonly name!: string;
  @Prop({ default: false }) readonly required!: boolean;
  @Inject() readonly $validator: any;

  get label() {
    return this.name.replace(/-/g, " ");
  }
}
</script>
