<template>
  <ValidationProvider v-slot="{ errors }" :vid="name" :name="name" :rules="rules">
  <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors.length > 0 ? errors : help">
      <b-input :value="value" v-bind="$attrs" :type="type" @input="input" />
    </b-field>
  </ValidationProvider>
</template>

<script lang="ts">
import { Component, Emit, Prop } from "vue-property-decorator";
import { ValidationProvider } from "vee-validate";
import Vue from "vue";

@Component({ components: { ValidationProvider } })
export default class ValidatedInput extends Vue {
  @Prop() readonly value!: string;
  @Prop({ default: "text" }) readonly type!: string;
  @Prop({ default: "" }) readonly help!: string;
  @Prop(Object) readonly rules!: object;

  get label() {
    return this.name.replace(/-/g, " ");
  }

  get name() {
    return this.$attrs.name || this.$attrs.label;
  }

  @Emit()
  input(event: Event) {
    return event;
  }
}
</script>
