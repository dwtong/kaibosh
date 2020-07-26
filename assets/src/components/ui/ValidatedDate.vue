<template>
  <ValidationProvider v-slot="{ errors }" :vid="name" :name="name" :rules="rules">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors">
      <b-datepicker
        placeholder="Click to select..."
        :value="dateValue"
        icon-pack="fas"
        :name="name"
        :disabled="disabled"
        @input="$emit('input', $event)"
      />
    </b-field>
  </ValidationProvider>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import { ValidationProvider } from "vee-validate";
import Vue from "vue";

@Component({ components: { ValidationProvider } })
export default class ValidatedDate extends Vue {
  @Prop({ default: "" }) readonly value!: Date | string;
  @Prop({ default: false }) readonly disabled!: boolean;
  @Prop(Object) readonly rules!: object;

  get dateValue() {
    if (!this.value || this.value === "") {
      return null;
    } else {
      return new Date(this.value);
    }
  }

  get label() {
    return this.name.replace(/-/g, " ");
  }

  get name() {
    return this.$attrs.name || this.$attrs.label;
  }
}
</script>
