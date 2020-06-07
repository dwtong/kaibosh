<template>
  <ValidationProvider :vid="name" :name="$attrs.label" :rules="rules" v-slot="{ errors }">
    <b-field v-bind="$attrs" :type="{ 'is-danger': errors[0] }" :message="errors">
      <b-select :value="value" @input="input" :name="name" :placeholder="placeholder" expanded>
        <slot />
      </b-select>
    </b-field>
  </ValidationProvider>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Emit, Prop } from "vue-property-decorator";
import { ValidationProvider } from "vee-validate";

@Component({ components: { ValidationProvider } })
export default class ValidatedSelect extends Vue {
  @Prop() readonly name!: string;
  @Prop() readonly rules!: Record<string, any>;
  @Prop() readonly value!: string;
  @Prop({ default: "" }) readonly placeholder!: string;

  @Emit()
  input(event: Event) {
    return event;
  }
}
</script>
