<template>
  <span>{{ sessionDayAndTime }}</span>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";
import { IRecipientSession } from "@/types";

@Component({ filters: { capitalize, formatTime } })
export default class SessionLabel extends Vue {
  @Prop() readonly session!: IRecipientSession;
  get sessionDayAndTime() {
    const day = this.session.day;
    const time = this.session.time;
    return day && time ? `${capitalize(day)} ${formatTime(time)}` : "";
  }
}
</script>
