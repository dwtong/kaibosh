<template>
  <b-field :label="label" class="form-field">
    <b-select
      v-validate="{ required: required }"
      :value="value"
      name="sessionSlot"
      placeholder="Select an option"
      expanded
      @input="$emit('input', $event)"
    >
      <option v-for="slot in sessionSlots" :key="slot.id" :value="slot.id"> {{ slot.day }} - {{ slot.time }} </option>
    </b-select>
  </b-field>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import SessionSlots from "@/store/modules/session-slots";
import { sortBy } from "lodash";

@Component
export default class SessionSlotSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;

  get sessionSlots() {
    return sortBy(SessionSlots.list, ["date"]);
  }
}
</script>
