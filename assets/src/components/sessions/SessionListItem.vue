<template>
  <div class="box" :class="{ 'is-hidden-print': plans.length === 0 }">
    <h2 v-if="sessionDate" class="title is-4">
      {{ sessionDate | formatDate("EEEE do MMMM yyyy") }}
    </h2>
    <div v-if="plans.length === 0" class="is-hidden-print">
      No sessions.
    </div>
    <div v-else class="columns">
      <div v-for="plan in plans" :key="plan.session.id" class="column is-half">
        <SessionRecipientList :plan="plan" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import SessionPlans from "@/store/modules/session-plans";
import { Component, Prop } from "vue-property-decorator";
import { dateOnDayOfWeek, formatDate } from "@/helpers/date";
import SessionRecipientList from "@/components/sessions/SessionRecipientList.vue";

@Component({ components: { SessionRecipientList }, filters: { formatDate } })
export default class ListSessions extends Vue {
  @Prop({ required: true }) readonly weekOfDate!: Date;
  @Prop({ required: true }) readonly day!: string;

  get sessionDate() {
    return dateOnDayOfWeek(this.weekOfDate, this.day);
  }

  get plans() {
    return SessionPlans.plansForDay(this.day);
  }
}
</script>
