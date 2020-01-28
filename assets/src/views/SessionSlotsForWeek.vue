<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Session Schedule</h1>
    </div>
    <div class="columns">
      <div class="column">
        <BaseSelect
          v-model="baseId"
          label="Kaibosh Base"
          required="true"
          @input="onBaseSelect"
        />
      </div>
      <div class="column">
        <div class="is-pulled-right field has-addons">
          <p class="control">
            <b-tooltip label="Previous Week">
              <router-link
                :to="`/sessions/week?date=${previousWeek}`"
                class="button is-large"
              >
                <span class="icon is-small">
                  <i class="fas fa-arrow-left"></i>
                </span>
              </router-link>
            </b-tooltip>
          </p>

          <p class="control">
            <b-tooltip label="Next Week">
              <router-link
                :to="`/sessions/week?date=${nextWeek}`"
                class="button is-large"
              >
                <span class="icon is-small">
                  <i class="fas fa-arrow-right"></i>
                </span>
              </router-link>
            </b-tooltip>
          </p>
        </div>
      </div>
    </div>

    <div v-if="showSessionOptions">
      <div class="box" v-for="day in days" :key="day">
        <h2 class="title is-4">
          {{ dateForDay(day) | moment("dddd Do MMMM YYYY") }}
        </h2>
        <div v-if="sessionsForDay(day).length === 0">No sessions.</div>
        <div v-else class="columns">
          <div
            v-for="session in sessionsForDay(day)"
            :key="session.id"
            class="column is-half"
          >
            <div class="card">
              <header class="card-header">
                <p class="card-header-title">
                  {{ session.time }}
                </p>

                <a href="#" class="card-header-icon" aria-label="more options">
                  <span class="icon">
                    <i class="fas fa-angle-down" aria-hidden="true"></i>
                  </span>
                </a>
              </header>
              <div class="card-content">
                <div v-if="session.recipients.length === 0">No recipients.</div>
                <div v-else class="content">
                  <div
                    v-for="recipient in session.recipients"
                    :key="recipient.id"
                  >
                    {{ recipient.name }}
                  </div>
                </div>
              </div>
              <footer class="card-footer">
                <router-link
                  :to="
                    `/sessions/${session.id}?date=${session.date.split(' ')[0]}`
                  "
                  class="card-footer-item"
                  >View Session</router-link
                >
              </footer>
            </div>
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
import date from "@/helpers/date";

@Component({ components: { BaseSelect, SessionSlotSelect } })
export default class SessionSlotsForWeek extends Vue {
  baseId: string = "0";
  sessionSlotId: string = "0";
  showSessionOptions = false;

  async onBaseSelect() {
    await BasesModule.fetchSessionSlots({
      baseId: this.baseId,
      date: date.getISODate(this.weekOfDate)
    });

    this.showSessionOptions = true;
  }

  sessionsForDay(day: string) {
    return this.sessionSlots.filter(s => s.day === day);
  }

  dateForDay(day: string) {
    const dateForDay = this.$moment(this.weekOfDate);
    const dayIndex = date.days.findIndex(d => d === day);
    return dateForDay.add(dayIndex, "day");
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
    let dateParam = this.$route.query.date && this.$route.query.date.toString();

    if (dateParam && dateParam.length > 0) {
      weekOfDate = new Date(dateParam);
    } else {
      weekOfDate = new Date();
    }

    return date.getMonday(weekOfDate);
  }

  get nextWeek() {
    let today = this.$moment(this.weekOfDate);
    return date.getISODate(today.add(7, "day").toDate());
  }

  get previousWeek() {
    let today = this.$moment(this.weekOfDate);
    return date.getISODate(today.add(-7, "day").toDate());
  }
}
</script>
