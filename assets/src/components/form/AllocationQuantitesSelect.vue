<template>
  <b-field>
    <b-select
      :disabled="disabled"
      :value="value"
      @input="$emit('input', $event)"
    >
      <option
        v-for="option in options"
        :key="option.value"
        :value="disabled ? null : option.value"
      >
        {{ option.name }}
      </option>
    </b-select>
  </b-field>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";

@Component
export default class AllocationQuantitiesSelect extends Vue {
  @Prop({ default: "" }) readonly value!: string;
  @Prop({ default: false }) readonly disabled!: boolean;

  get options() {
    return [
      { value: "", name: "No limit" },
      { value: "0.5", name: "1/2" },
      { value: "1.0", name: "1" },
      { value: "2.0", name: "2" },
      { value: "3.0", name: "3" },
      { value: "4.0", name: "4" },
      { value: "5.0", name: "5" },
      { value: "6.0", name: "6" },
      { value: "7.0", name: "7" },
      { value: "8.0", name: "8" },
      { value: "9.0", name: "9" },
      { value: "10.0", name: "10" }
    ];
  }
}
</script>
