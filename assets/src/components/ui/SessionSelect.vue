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
    <option v-for="slot in sessions" :key="slot.id" :value="slot.id">
      {{ slot.day | capitalize }} - {{ slot.time | formatTime }}
    </option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import Sessions from "@/store/modules/session-slots";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";
import { IScheduledSession } from "@/types";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";

@Component({ components: { ValidatedSelect }, filters: { capitalize, formatTime } })
export default class SessionSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: false }) readonly disabled!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly recipientSessions?: IScheduledSession[];
  @Prop() readonly value!: string;
  sessions = Sessions.sortedList;
}
</script>
