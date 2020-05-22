<template>
  <b-field
    :label="label"
    :type="{ 'is-danger': $validator.errors.has('base') }"
    :message="$validator.errors.first('base')"
    class="form-field"
  >
    <b-select
      :value="value"
      @input="$emit('input', $event)"
      name="base"
      placeholder="Please select a base..."
      v-validate="{ required: required }"
      expanded
    >
      <option v-if="all" :value="allValue">All</option>
      <option v-for="base in list" :key="base.id" :value="base.id">{{ base.name }}</option>
    </b-select>
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Vue from "vue";
import { AllRecipientsModule } from "@/store/modules/all-recipients";
import { BasesModule } from "@/store/modules/bases";
import { IBase } from "@/types";
import { Validator } from "vee-validate";

@Component
export default class BaseSelect extends Vue {
  @Prop({ default: false }) readonly all!: boolean;
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;
  @Inject("$validator") $validator!: Validator;

  list: IBase[] = [];
  allValue = 0;

  async created() {
    await BasesModule.fetchBases();
    this.list = BasesModule.list;
  }
}
</script>
