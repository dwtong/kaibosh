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
import { defineComponent } from "vue";
import Sessions from "@/store/modules/sessions";
import SessionPlans from "@/store/modules/session-plans";
import BaseSelect from "@/components/ui/BaseSelect.vue";
import SessionListItem from "@/components/sessions/SessionListItem.vue";
import WeekDateControls from "@/components/sessions/WeekDateControls.vue";
import { mondayOfWeek, thisWeek, formatDate } from "@/helpers/date";
import App from "@/store/modules/app";
import { useRoute } from "vue-router";

export default defineComponent({
  components: {
    BaseSelect,
    SessionListItem,
    WeekDateControls
  },
  setup() {
    const baseId = localStorage.getItem("baseId");
    let showSessionOptions;
    const route = useRoute();

    const fetchPlans = async (baseId: string) => {
      const dateParam = route.query.date?.toString();
      App.enableLoading();

      if (baseId && baseId !== "0") {
        let weekOfDate: string | Date = dateParam ? mondayOfWeek(new Date(dateParam)) : thisWeek;
        weekOfDate = formatDate(weekOfDate, "yyyy-MM-dd");
        await Sessions.fetchList(baseId);
        await SessionPlans.fetchPlanList({ baseId, weekOfDate });
        showSessionOptions = true;
      } else {
        showSessionOptions = false;
      }
      App.disableLoading();
    };

    baseId && fetchPlans(baseId);

    return {
      baseId,
      showSessionOptions,
      fetchPlans
    };
  },
  data() {
    return {
      sessionId: "0"
    };
  }
  // computed: {
  //   showSubmitButton() {
  //     const baseId = localStorage.getItem("baseId");
  //     return baseId !== "0" && this.sessionId !== "0";
  //   },

  //   days() {
  //     return listOfDays;
  //   }
  // },
  // methods: {
  //   async setBase(baseId: string) {
  //     localStorage.setItem("baseId", baseId);
  //     await this.fetchPlans(baseId);
  //     this.showSessionOptions = true;
  //   }
  // }
});
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
