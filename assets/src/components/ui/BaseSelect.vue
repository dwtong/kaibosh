<template>
  <ValidatedSelect
    name="base"
    :rules="{ required: required }"
    :value="value"
    @input="input"
    :label="label"
    placeholder="Select a base..."
  >
    <option v-if="all" :value="allValue">All</option>
    <option v-for="base in list" :key="base.id" :value="base.id">{{ base.name }}</option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Emit, Prop } from "vue-property-decorator";
import Vue from "vue";
import Bases from "@/store/modules/bases";
import { IBase } from "@/types";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";

@Component({ components: { ValidatedSelect } })
export default class BaseSelect extends Vue {
  @Prop({ default: false }) readonly all!: boolean;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;

  list: IBase[] = [];
  allValue = 0;

  async created() {
    await Bases.fetchBases();
    this.list = Bases.list;
  }

  @Emit()
  input(event: Event) {
    return event;
  }
}
</script>
