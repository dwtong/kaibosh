<template>
  <ValidatedSelect
    name="base"
    :rules="{ required: required }"
    :value="value"
    :label="label"
    placeholder="Select a base..."
    @input="input"
  >
    <option v-if="all" :value="allValue">All</option>
    <option v-for="base in list" :key="base.id" :value="base.id">{{ base.name }}</option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Emit, Prop } from "vue-property-decorator";
import Vue from "vue";
import App from "@/store/modules/app";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";

@Component({ components: { ValidatedSelect } })
export default class BaseSelect extends Vue {
  @Prop({ default: false }) readonly all!: boolean;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;

  allValue = 0;

  get list() {
    return App.bases;
  }

  @Emit()
  input(event: Event) {
    return event;
  }
}
</script>
