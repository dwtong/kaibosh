<template>
  <b-field
    :label="label"
    :type="{ 'is-danger': $validator.errors.has('sessionSlot') }"
    :message="$validator.errors.first('sessionSlot')"
    class="form-field"
  >
    <b-select
      :value="value"
      @input="$emit('input', $event)"
      name="sessionSlot"
      placeholder="Select an option"
      v-validate="{ required: required }"
      expanded
    >
      <option v-for="slot in sessionSlots" :key="slot.id" :value="slot.id">
        {{ slot.day }} - {{ slot.time }}
      </option>
    </b-select>
  </b-field>
</template>

<script lang="ts">
import { Component, Inject, Prop } from "vue-property-decorator";
import Vue from "vue";
import { BasesModule } from "@/store/modules/bases";
import { Validator } from "vee-validate";
import { sortBy } from "lodash";

@Component
export default class SessionSlotSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly value!: string;
  @Inject("$validator") $validator!: Validator;

  get sessionSlots() {
    return sortBy(BasesModule.sessionSlots, ["date"]);
  }
}
</script>
