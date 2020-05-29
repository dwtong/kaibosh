<template>
  <div>
    <div class="title-box is-hidden-print">
      <h1 class="title is-inline-block">Session Schedule</h1>
    </div>
    <div class="columns">
      <div class="column is-hidden-print">
        <BaseSelect class="" :value="baseId" required="true" @input="setBase" />
      </div>
      <div class="column is-hidden-print">
        <WeekDateControls :baseId="baseId" :date="weekOfDate" />
      </div>
    </div>

    <div v-if="showSessionOptions">
      <div class="box" v-for="day in days" :key="day" :class="{ 'is-hidden-print': sessionsForDay(day).length === 0 }">
        <h2 class="title is-4">
          {{ dateForDay(day) | moment("dddd Do MMMM YYYY") }}
        </h2>
        <div v-if="sessionsForDay(day).length === 0" class="is-hidden-print">
          No sessions.
        </div>
        <div v-else class="columns">
          <div v-for="session in sessionsForDay(day)" :key="session.id" class="column is-half">
            <SessionSummaryCard :session="session" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import { BasesModule } from "../store/modules/bases";
import BaseSelect from "@/components/form/BaseSelect.vue";
import SessionSlotSelect from "@/components/form/SessionSlotSelect.vue";
import SessionSummaryCard from "@/components/SessionSummaryCard.vue";
import WeekDateControls from "@/components/WeekDateControls.vue";
import date from "@/helpers/date";
import moment from "moment";
import { sortBy } from "lodash";

@Component({
  components: {
    BaseSelect,
    SessionSlotSelect,
    SessionSummaryCard,
    WeekDateControls
  }
})
export default class SessionsByWeek extends Vue {
  sessionSlotId = "0";
  showSessionOptions = true;
  baseId = localStorage.getItem("baseId");

  async created() {
    if (this.baseId !== "0") {
      this.fetchSessions();

      this.showSessionOptions = true;
    } else {
      this.showSessionOptions = false;
    }
  }

  async setBase(baseId: string) {
    localStorage.setItem("baseId", baseId);
    this.baseId = baseId;
    await this.fetchSessions();
    this.showSessionOptions = true;
  }

  sessionsForDay(day: string) {
    return sortBy(
      this.sessionSlots.filter(s => s.day === day),
      "date"
    );
  }

  dateForDay(day: string) {
    const dateForDay = moment(this.weekOfDate);
    const dayIndex = date.days.findIndex(d => d === day);
    return dateForDay.add(dayIndex, "day");
  }

  async fetchSessions() {
    if (this.baseId) {
      await BasesModule.fetchSessionSlots({
        baseId: this.baseId,
        date: date.getISODate(this.weekOfDate)
      });
    }
  }

  get sessionSlots() {
    return BasesModule.sessionSlots;
  }

  get showSubmitButton() {
    return this.baseId !== "0" && this.sessionSlotId !== "0";
  }

  get days() {
    return date.days;
  }

  get weekOfDate() {
    let weekOfDate;
    const dateParam = this.$route.query.date && this.$route.query.date.toString();

    if (dateParam && dateParam.length > 0) {
      weekOfDate = new Date(dateParam);
    } else {
      weekOfDate = new Date();
    }

    return date.getMonday(weekOfDate);
  }
}
</script>

<style lang="scss" scoped>
.box {
  @media print {
    padding: 10px;
  }
}

.card-header {
  background-color: #e6e6e6;
}

.title {
  @media print {
    font-size: 16px !important;
    margin-bottom: 10px !important;
  }
}
</style>
