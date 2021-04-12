<template>
  <div class="box" :class="{ 'is-hidden-print': plans.length === 0 }">
    <h2 class="title is-4">{{ sessionDate }}</h2>
    <div v-if="plans.length === 0" class="is-hidden-print">No sessions.</div>
    <div v-else class="columns">
      <div v-for="plan in plans" :key="plan.session.id" class="column is-half">
        <SessionRecipientList :plan="plan" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import SessionPlans from "@/store/modules/session-plans";
import { dateOnDayOfWeek, formatDate } from "@/helpers/date";
import SessionRecipientList from "@/components/sessions/SessionRecipientList.vue";

export default defineComponent({
  components: {
    SessionRecipientList
  },
  props: {
    weekOfDate: {
      type: Date,
      required: true
    },
    day: {
      type: String,
      required: true
    }
  },
  computed: {
    sessionDate(): string {
      const date = dateOnDayOfWeek(this.weekOfDate, this.day);
      return date ? formatDate(date, "EEEE do MMMM yyyy") : "";
    },

    plans(): any {
      return SessionPlans.plansForDay(this.day);
    }
  }
});
</script>
