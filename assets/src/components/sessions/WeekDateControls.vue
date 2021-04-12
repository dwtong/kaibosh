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
import { defineComponent } from "vue";
import Router from "@/router";
import { formatDate, subWeeks, addWeeks } from "@/helpers/date";
import WeekDatePicker from "@/components/ui/WeekDatePicker.vue";

export default defineComponent({
  components: {
    WeekDatePicker
  },
  props: {
    date: {
      type: Date,
      required: true
    }
  },
  data() {
    return {};
  },
  computed: {
    previousWeek(): Date {
      return subWeeks(this.date, 1);
    },

    nextWeek(): Date {
      return addWeeks(this.date, 1);
    }
  },
  methods: {
    goToDate(datetime: Date) {
      const date = formatDate(datetime, "yyyy-MM-dd");
      Router.push({ path: "/sessions/week", query: { date } });
    }
  }
});
</script>
