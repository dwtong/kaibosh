<template>
  <b-field
    :label="label"
    :type="{ 'is-danger': errors.has('base') }"
    :message="errors.first('base')"
    class="form-field"
  >
    <b-select
      :value="value"
      @input="$emit('input', $event)"
      name="base"
      placeholder="Select an option"
      v-validate="'required'"
      expanded
    >
      <option v-if="all" :value="allValue">All</option>
      <option v-for="base in list" :key="base.id" :value="base.id">{{
        base.name
      }}</option>
    </b-select>
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Vue from "vue";
import { AllRecipientsModule } from "@/store/modules/all-recipients";
import BaseService from "@/services/base-service";
import { IBase } from "@/types";

@Component
export default class BaseSelect extends Vue {
  @Prop({ default: false }) readonly all!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;
  @Inject() readonly $validator: any;

  list: IBase[] = [];
  allValue: number = 0;

  async created() {
    try {
      const response = await BaseService.get();
      this.list = response;
    } catch {
      this.list = [];
    }
  }
}
</script>
