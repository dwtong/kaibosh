<template>
  <ValidationProvider :vid="name" :name="name" :rules="rules" v-slot="{ errors }">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors">
      <b-input :value="value" @input="input" v-bind="$attrs" :type="type" />
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
