<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Session Schedule</h1>
    </div>
    <div class="columns">
      <div class="column">
        <BaseSelect :value="baseId" required="true" @input="setBase" />
      </div>
      <div class="column">
        <div class="is-pulled-right field has-addons">
          <p class="control">
            <b-tooltip label="Previous Week">
              <router-link
                :to="{
                  path: '/sessions/week',
                  query: { date: previousWeek, base_id: baseId }
                }"
                class="button"
              >
                <span class="icon is-small">
                  <i class="fas fa-arrow-left"></i>
                </span>
              </router-link>
            </b-tooltip>
          </p>

          <p class="control">
            <router-link
              :to="{
                path: '/sessions/week',
                query: { base_id: baseId }
              }"
              class="button"
              :class="{ 'is-static': isToday }"
            >
              Today
            </router-link>
          </p>

          <p class="control">
            <b-tooltip label="Next Week">
              <router-link
                :to="{
                  path: '/sessions/week',
                  query: { date: nextWeek, base_id: baseId }
                }"
                class="button"
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
              </header>

              <div class="card-content">
                <div v-if="session.recipients.length === 0">No recipients.</div>
                <div v-else class="content">
                  <div
                    v-for="recipient in sortRecipients(session.recipients)"
                    :key="recipient.id"
                  >
                    <AllocationRecipient :recipient="recipient" />
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
import AllocationRecipient from "@/components/AllocationRecipient.vue";
import BaseSelect from "@/components/form/BaseSelect.vue";
import SessionSlotSelect from "@/components/form/SessionSlotSelect.vue";
import Router from "@/router";
import date from "@/helpers/date";
import moment from "moment";
import { sortBy } from "lodash";

@Component({
  components: { AllocationRecipient, BaseSelect, SessionSlotSelect }
})
export default class SessionsByWeek extends Vue {
  sessionSlotId: string = "0";
  showSessionOptions = true;
  baseId = localStorage.getItem("baseId") || "0";

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
    return this.sessionSlots.filter(s => s.day === day);
  }

  sortRecipients(list: any) {
    return sortBy(list, ["name"]);
  }

  dateForDay(day: string) {
    const dateForDay = moment(this.weekOfDate);
    const dayIndex = date.days.findIndex(d => d === day);
    return dateForDay.add(dayIndex, "day");
  }

  async fetchSessions() {
    await BasesModule.fetchSessionSlots({
      baseId: this.baseId,
      date: date.getISODate(this.weekOfDate)
    });
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

  get isToday() {
    const today = date.getISODate(date.getMonday(new Date()));
    const weekOf = date.getISODate(this.weekOfDate);

    return today === weekOf;
  }

  get weekOfDate() {
    let weekOfDate;
    const dateParam =
      this.$route.query.date && this.$route.query.date.toString();

    if (dateParam && dateParam.length > 0) {
      weekOfDate = new Date(dateParam);
    } else {
      weekOfDate = new Date();
    }

    return date.getMonday(weekOfDate);
  }

  get nextWeek() {
    const today = moment(this.weekOfDate);
    return date.getISODate(today.add(7, "day").toDate());
  }

  get previousWeek() {
    const today = moment(this.weekOfDate);
    return date.getISODate(today.add(-7, "day").toDate());
  }
}
</script>

<style lang="scss" scoped>
.card-header {
  background-color: #e6e6e6;
}
</style>
