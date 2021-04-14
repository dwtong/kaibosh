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
import { listOfDays, mondayOfWeek, thisWeek, formatDate } from "@/helpers/date";
import App from "@/store/modules/app";

export default defineComponent({
  components: {
    BaseSelect,
    SessionListItem,
    WeekDateControls
  },
  setup() {
    const baseId = localStorage.getItem("baseId");
    if (baseId && baseId !== "0") {
      this.fetchPlans();

      this.showSessionOptions = true;
    } else {
      this.showSessionOptions = false;
    }
  },
  data() {
    return {
      sessionId: "0",
      showSessionOptions: true
    };
  },
  computed: {
    showSubmitButton() {
      return this.baseId !== "0" && this.sessionId !== "0";
    },

    days() {
      return listOfDays;
    },

    weekOfDate() {
      const dateParam = this.$route.query.date?.toString();

      if (dateParam) {
        return mondayOfWeek(new Date(dateParam));
      } else {
        return thisWeek;
      }
    }
  },
  methods: {
    async fetchPlans() {
      App.enableLoading();

      if (this.baseId) {
        const weekOfDate = formatDate(this.weekOfDate, "yyyy-MM-dd");
        await Sessions.fetchList(this.baseId);
        await SessionPlans.fetchPlanList({ baseId: this.baseId, weekOfDate });
      }
      App.disableLoading();
    },

    async setBase(baseId: string) {
      localStorage.setItem("baseId", baseId);
      this.baseId = baseId;
      await this.fetchPlans();
      this.showSessionOptions = true;
    }
  }
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
