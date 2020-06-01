<template>
  <b-field :label="label" :type="{ 'is-danger': $validator.errors.has(name) }" :message="$validator.errors.first(name)">
    <b-datepicker
      placeholder="Click to select..."
      :value="value"
      @input="$emit('input', $event)"
      :data-vv-as="label"
      icon-pack="fas"
      :name="name"
      :disabled="disabled"
      v-validate="{ required: required }"
    />
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Vue from "vue";
import { Validator } from "vee-validate";

@Component
export default class DateField extends Vue {
  @Prop() readonly value!: string;
  @Prop({ default: "" }) readonly name!: string;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;
  @Inject("$validator") $validator!: Validator;

  get label() {
    return this.name.replace(/-/g, " ");
  }
}
</script>
