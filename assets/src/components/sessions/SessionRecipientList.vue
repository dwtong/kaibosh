<template>
  <div class="card">
    <header class="card-header">
      <p class="card-header-title">{{ sessionTime }}</p>
    </header>

    <div class="card-content">
      <div v-if="plan.recipients.length === 0" class="is-italic is-hidden-print">No recipients.</div>
      <div v-else class="content">
        <div v-for="recipient in sortRecipients(plan.recipients)" :key="recipient.id">
          <SessionRecipient :recipient="recipient" />
        </div>
      </div>
    </div>
    <footer class="card-footer is-hidden-print">
      <router-link :to="`/sessions/${plan.session.id}?date=${date}`" class="card-footer-item">View Session</router-link>
    </footer>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import SessionRecipient from "@/components/sessions/SessionRecipient.vue";
import { sortBy } from "lodash";
import { formatDate, formatTime } from "@/helpers/date";

export default defineComponent({
  components: {
    SessionRecipient
  },
  props: {
    plan: {
      type: Object,
      required: true
    }
  },
  data() {
    return {};
  },
  computed: {
    date(): string {
      const sessionDate = new Date(this.plan.session.date);
      return formatDate(sessionDate, "yyyy-MM-dd");
    },
    sessionTime(): string {
      const time = this.plan.session.time;
      return time ? formatTime(time) : "";
    }
  },
  methods: {
    sortRecipients(list: any) {
      return sortBy(list, ["name"]);
    }
  }
});
</script>

<style lang="scss" scoped>
.card-content {
  @media print {
    padding: 5px;
    font-size: 12px;
  }
}

.card-header {
  background-color: #f3fff3;
  box-shadow: 0 0.025em 0.25em rgba(1, 1, 1, 0.1);
}

.card-footer {
  background-color: #f8f8f8;
}

.card-header-title {
  @media print {
    padding: 5px;
    font-size: 12px;
  }
}
</style>
