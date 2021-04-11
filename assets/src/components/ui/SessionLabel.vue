<template>
  <span>{{ sessionDayAndTime }}</span>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";

export default defineComponent({
  props: {
    session: {
      type: Object,
      required: true
    }
  },
  computed: {
    sessionDayAndTime(): string {
      const day = this.session.day;
      const time = this.session.time;
      return day && time ? `${capitalize(day)} ${formatTime(time)}` : "";
    }
  }
});
</script>
