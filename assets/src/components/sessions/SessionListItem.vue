<template>
  <div class="box" :class="{ 'is-hidden-print': sessions.length === 0 }">
    <h2 class="title is-4">
      {{ sessionDate | formatDate("dddd Do MMMM YYYY") }}
    </h2>
    <div v-if="sessions.length === 0" class="is-hidden-print">
      No sessions.
    </div>
    <div v-else class="columns">
      <div v-for="session in sessions" :key="session.id" class="column is-half">
        <SessionRecipientList :session="session" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import Bases from "@/store/modules/bases";
import { Component, Prop } from "vue-property-decorator";
import { dateOnDayOfWeek, formatDate } from "@/helpers/date";
import SessionRecipientList from "@/components/sessions/SessionRecipientList.vue";

@Component({ components: { SessionRecipientList }, filters: { formatDate } })
export default class ListSessions extends Vue {
  @Prop({ required: true }) readonly dateOfWeek!: Date;
  @Prop({ required: true }) readonly day!: string;

  get sessionDate() {
    return dateOnDayOfWeek(this.dateOfWeek, this.day);
  }

  get sessions() {
    return Bases.sessionsForDay(this.day);
  }
}
</script>
