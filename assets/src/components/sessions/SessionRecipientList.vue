<template>
  <div class="card">
    <header class="card-header">
      <p v-if="plan.session.time" class="card-header-title">
        {{ plan.session.time | formatTime }}
      </p>
    </header>

    <div class="card-content">
      <div v-if="plan.recipients.length === 0" class="is-hidden-print">
        No recipients.
      </div>
      <div v-else class="content">
        <div v-for="recipient in sortRecipients(plan.recipients)" :key="recipient.id">
          <SessionRecipient :recipient="recipient" />
        </div>
      </div>
    </div>
    <footer class="card-footer is-hidden-print">
      <router-link
        :to="`/sessions/${plan.session.id}?baseId=${plan.session.baseId}&date=${date}`"
        class="card-footer-item"
        >View Session</router-link
      >
    </footer>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import SessionRecipient from "@/components/sessions/SessionRecipient.vue";
import { sortBy } from "lodash";
import { formatDate, formatTime } from "@/helpers/date";
import { ISessionPlan } from "@/types";

@Component({ components: { SessionRecipient }, filters: { formatTime } })
export default class SessionRecipientList extends Vue {
  @Prop() readonly plan!: ISessionPlan;

  sortRecipients(list: any) {
    return sortBy(list, ["name"]);
  }

  get date() {
    const sessionDate = new Date(this.plan.session.date)
    return formatDate(sessionDate, "yyyy-MM-dd");
  }
}
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
