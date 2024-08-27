<script setup lang="ts">
import type { SessionPlan } from "@/api/sessions"
import { formatTime } from "@/utils/date"
import { sortBy } from "es-toolkit"
import { computed } from "vue"
import SessionRecipient from "./SessionRecipient.vue"

const props = defineProps<{
  plan: SessionPlan
  date: string
}>()

const recipients = computed(() => {
  return sortBy(props.plan.recipients, ["name"])
})
</script>

<template>
  <div class="card">
    <header class="card-header">
      <p v-if="plan.session.time" class="card-header-title">
        {{ formatTime(plan.session.time) }}
      </p>
    </header>

    <div class="card-content">
      <div
        v-if="plan.recipients.length === 0"
        class="is-italic is-hidden-print"
      >
        No recipients.
      </div>
      <div v-else class="content">
        <div v-for="recipient in recipients" :key="recipient.id">
          <SessionRecipient :recipient="recipient" />
        </div>
      </div>
    </div>
    <footer class="card-footer is-hidden-print">
      <router-link
        :to="`/sessions/${plan.session.id}?date=${date}`"
        class="card-footer-item"
        >View Session</router-link
      >
    </footer>
  </div>
</template>

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
