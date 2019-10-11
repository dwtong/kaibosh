<template>
  <b-field
    :label="label"
    :type="{ 'is-danger': $validator.errors.has(name) }"
    :message="$validator.errors.first(name)"
  >
    <b-input
      :value="value"
      @input="$emit('input', $event)"
      :data-vv-as="label"
      :name="name"
      v-validate="validationRules"
      :type="type"
      :vid="name"
    />
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop, PropSync } from "vue-property-decorator";
import Vue from "vue";
import { Validator } from "vee-validate";

@Component
export default class InputField extends Vue {
  @Prop() readonly value: any;
  @Prop({ default: "" }) readonly name!: string;
  @Prop({ default: "text" }) readonly type!: string;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: {} }) readonly validation!: object;
  @Inject("$validator") $validator!: Validator;

  get label() {
    return this.name.replace(/-/g, " ");
  }

  get validationRules() {
    return { required: this.required, ...this.validation };
  }
}
</script>
