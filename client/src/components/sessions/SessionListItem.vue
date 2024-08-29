<script setup lang="ts">
import { useSessionPlansStore } from "@/stores/session-plans"
import { dateOnDayOfWeek, formatDate, type Day } from "@/utils/date"
import { computed } from "vue"
import SessionRecipientList from "./SessionRecipientList.vue"

const props = defineProps<{
  weekOfDate: Date
  day: Day
  baseId: string
}>()
const { plansForDay } = useSessionPlansStore()
const plans = computed(() => plansForDay(props.day))

const sessionDate = computed(() => {
  const dateOnDay = dateOnDayOfWeek(props.weekOfDate, props.day)
  return formatDate(dateOnDay, "EEEE do MMMM yyyy")
})
</script>

<template>
  <div class="box" :class="{ 'is-hidden-print': plans.length === 0 }">
    <h2 v-if="sessionDate" class="title is-4">
      {{ sessionDate }}
    </h2>
    <div v-if="plans.length === 0" class="is-hidden-print">No sessions.</div>
    <div v-else class="columns">
      <div v-for="plan in plans" :key="plan.session.id" class="column is-half">
        <SessionRecipientList
          :plan="plan"
          :date="plan.session.date"
          :base-id="baseId"
        />
      </div>
    </div>
  </div>
</template>

<style scoped>
.box {
  break-inside: avoid;
}
</style>
