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
      <WeekDatePicker @input="goToDate($event)" :value="date" />
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
import { lastWeek, nextWeek, formatDate } from "@/helpers/date";
import WeekDatePicker from "@/components/ui/WeekDatePicker.vue";

@Component({ components: { WeekDatePicker } })
export default class WeekDateControls extends Vue {
  @Prop(Date) readonly date!: Date;
  nextWeek: Date = nextWeek;
  previousWeek: Date = lastWeek;

  goToDate(datetime: Date) {
    const date = formatDate(datetime, "yyyy-MM-dd");
    Router.push({ path: "/sessions/week", query: { date } });
  }
}
</script>
