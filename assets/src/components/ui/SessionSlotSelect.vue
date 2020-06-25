<template>
  <ValidatedSelect
    :rules="{ required: required }"
    :value="value"
    :disabled="disabled"
    name="Session slot"
    placeholder="Select an option"
    expanded
    @input="$emit('input', $event)"
  >
    <option v-for="slot in sessionSlots" :key="slot.id" :value="slot.id"> {{ slot.day }} - {{ slot.time }} </option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import SessionSlots from "@/store/modules/session-slots";
import { sortBy } from "lodash";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";
import { IScheduledSession } from "@/types";

@Component({ components: { ValidatedSelect } })
export default class SessionSlotSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly sessions?: IScheduledSession[];
  @Prop() readonly value!: string;

  get sessionSlots() {
    return sortBy(SessionSlots.list, ["date"]);
  }
}
</script>
