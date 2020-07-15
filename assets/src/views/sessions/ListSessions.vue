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
        <WeekDateControls :base-id="baseId" :date="weekOfDate" />
      </div>
    </div>

    <div v-if="showSessionOptions">
      <SessionListItem v-for="day in days" :key="day" :week-of-date="weekOfDate" :day="day" />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import SessionSlots from "@/store/modules/session-slots";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import SessionListItem from "@/components/sessions/SessionListItem.vue";
import WeekDateControls from "@/components/sessions/WeekDateControls.vue";
import { listOfDays, mondayOfWeek, thisWeek } from "@/helpers/date";
import App from "@/store/modules/app";

@Component({ components: { BaseSelect, SessionListItem, WeekDateControls } })
export default class ListSessions extends Vue {
  sessionSlotId = "0";
  showSessionOptions = true;
  baseId = localStorage.getItem("baseId");

  async created() {
    if (this.baseId && this.baseId !== "0") {
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

  async fetchSessions() {
    App.enableLoading();

    if (this.baseId) {
      // TODO: fetch session list
      // const date = formatDate(this.weekOfDate, "yyyy-MM-dd");
      await SessionSlots.fetchList({ baseId: this.baseId });
    }
    App.disableLoading();
  }

  get showSubmitButton() {
    return this.baseId !== "0" && this.sessionSlotId !== "0";
  }

  get days() {
    return listOfDays;
  }

  get weekOfDate() {
    const dateParam = this.$route.query.date?.toString();

    if (dateParam) {
      return mondayOfWeek(new Date(dateParam));
    } else {
      return thisWeek;
    }
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
