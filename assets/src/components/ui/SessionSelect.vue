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
      {{ session.day | capitalize }} - {{ session.time | formatTime }}
    </option>
  </ValidatedSelect>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import Sessions from "@/store/modules/sessions";
import ValidatedSelect from "@/components/ui/ValidatedSelect.vue";
import { IRecipientSession } from "@/types";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";

@Component({ components: { ValidatedSelect }, filters: { capitalize, formatTime } })
export default class SessionSelect extends Vue {
  @Prop({ default: false }) readonly required!: boolean;
  @Prop({ default: "" }) readonly label!: string;
  @Prop() readonly recipientSessions?: IRecipientSession[];
  @Prop() readonly value!: string;
  sessions = Sessions.sortedList;
}
</script>
