<template>
  <ValidatedSelect
    :rules="{ required: required }"
    :value="value"
    name="Session"
    placeholder="Select an option"
    expanded
    @input="$emit('input', $event)"
  >
    <option v-for="session in sessions" :key="session.id" :value="session.id">
      <SessionLabel :session="session" />
    </option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import Sessions from "@/store/modules/sessions";
import SessionLabel from "@/components/ui/SessionLabel.vue";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";
import { IRecipientSession } from "@/types";

@Component({ components: { SessionLabel, ValidatedSelect } })
export default class SessionSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly recipientSessions?: IRecipientSession[];
  @Prop() readonly value!: string;
  sessions = Sessions.sortedList;
}
</script>
