<script setup lang="ts">
import SessionListItem from "@/components/sessions/SessionListItem.vue"
import WeekDateControls from "@/components/sessions/WeekDateControls.vue"
import BaseSelect from "@/components/ui/BaseSelect.vue"
import { useSessionPlansStore } from "@/stores/session-plans"
import { listOfDays, mondayOfWeek, thisWeek } from "@/utils/date"
import { computed, ref, watch } from "vue"
import { useRoute } from "vue-router"

const route = useRoute()
const sessionPlansStore = useSessionPlansStore()
const baseId = ref(localStorage.getItem("baseId") || "")
const showSessions = ref(!!baseId.value)
const weekOfDate = computed(() => {
  const dateParam = route.query?.date?.toString()
  return dateParam ? mondayOfWeek(new Date(dateParam)) : thisWeek
})

function setBase(event: Event) {
  const { value } = event.target as HTMLInputElement
  baseId.value = value
  showSessions.value = true
  localStorage.setItem("baseId", value)
}

watch(baseId, () =>
  sessionPlansStore.fetchPlanList(baseId.value, weekOfDate.value),
)
if (baseId.value) {
  sessionPlansStore.fetchPlanList(baseId.value, weekOfDate.value)
}
</script>

<template>
  <div>
    <div class="title-box is-hidden-print">
      <h1 class="title is-inline-block">Session Schedule</h1>
    </div>
    <div class="columns">
      <div class="column is-hidden-print">
        <BaseSelect :value="baseId" @input="setBase" />
      </div>
      <div class="column is-hidden-print">
        <WeekDateControls :base-id="baseId" :date="weekOfDate" />
      </div>
    </div>

    <div v-if="showSessions" class="list-view">
      <SessionListItem
        v-for="day in listOfDays"
        :key="day"
        :week-of-date="weekOfDate"
        :day="day"
      />
    </div>
  </div>
</template>

<style scoped>
.box {
  @media print {
    padding: 10px;
  }
}

.card-header {
  background-color: #e6e6e6;
}

.list-view {
  margin-top: -23rem;
}

.title {
  @media print {
    font-size: 16px !important;
    margin-bottom: 10px !important;
  }
}
</style>
