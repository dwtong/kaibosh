<template>
  <div class="is-pulled-right field has-addons">
    <p class="control">
      <b-tooltip label="Previous Week">
        <button class="button" @click="goToDate(previousWeek)">
          <span class="icon is-small">
            <i class="fas fa-arrow-left"></i>
          </span>
        </button>
      </b-tooltip>
    </p>

    <p class="control">
      <WeekDatePicker :value="date" @input="goToDate($event)" />
    </p>

    <p class="control">
      <b-tooltip label="Next Week">
        <button class="button" @click="goToDate(nextWeek)">
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
import { formatDate, subWeeks, addWeeks } from "@/helpers/date";
import WeekDatePicker from "@/components/ui/WeekDatePicker.vue";

@Component({ components: { WeekDatePicker } })
export default class WeekDateControls extends Vue {
  @Prop(Date) readonly date!: Date;

  goToDate(datetime: Date) {
    const date = formatDate(datetime, "yyyy-MM-dd");
    Router.push({ path: "/sessions/week", query: { date } });
  }

  get previousWeek() {
    return subWeeks(this.date, 1);
  }

  get nextWeek() {
    return addWeeks(this.date, 1);
  }
}
</script>
