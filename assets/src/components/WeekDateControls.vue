<template>
  <div class="is-pulled-right field has-addons">
    <p class="control">
      <b-tooltip label="Previous Week">
        <button @click="goToDate(previousWeek)" class="button">
          <span class="icon is-small">
            <i class="fas fa-arrow-left"></i>
          </span>
        </button>
      </b-tooltip>
    </p>

    <p class="control">
      <WeekDatePicker @input="goToSelectedDate($event)" :value="date" />
    </p>

    <p class="control">
      <b-tooltip label="Next Week">
        <button @click="goToDate(nextWeek)" class="button">
          <span class="icon is-small">
            <i class="fas fa-arrow-right"></i>
          </span>
        </button>
      </b-tooltip>
    </p>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import Router from "@/router";
import dateHelper from "@/helpers/date";
import moment from "moment";
import WeekDatePicker from "@/components/WeekDatePicker.vue";

@Component({ components: { WeekDatePicker } })
export default class SessionsByWeek extends Vue {
  @Prop(String) readonly baseId!: string;
  @Prop(Date) readonly date!: Date;

  get nextWeek() {
    const today = moment(this.date);
    return dateHelper.getISODate(today.add(7, "day").toDate());
  }

  get previousWeek() {
    const today = moment(this.date);
    return dateHelper.getISODate(today.add(-7, "day").toDate());
  }

  goToSelectedDate(date: Date) {
    const dateString = dateHelper.getISODate(date);
    this.goToDate(dateString);
  }

  goToDate(date?: string) {
    const query: any = { base_id: this.baseId };

    if (date) {
      query.date = date;
    }

    Router.push({ path: "/sessions/week", query });
  }
}
</script>
