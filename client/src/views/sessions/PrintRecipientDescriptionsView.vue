<script setup lang="tsx">
import CheckBox from "@/components/ui/CheckBox.vue"
import { useSessionPlansStore } from "@/stores/session-plans"
import { formatDate } from "@/utils/date"
import { storeToRefs } from "pinia"
import { computed, ref } from "vue"
import { useRoute, useRouter } from "vue-router"

const router = useRouter()
const route = useRoute()
const sessionPlansStore = useSessionPlansStore()
const { orderedRecipients, planDetails } = storeToRefs(sessionPlansStore)
const sessionId = route.params.id as string
const baseId = route.query.baseId as string
const date = route.query.date as string
const includeOnHold = ref(false)
const sessionDate = computed(() => {
  if (planDetails.value == null) return null
  const { date, time } = planDetails.value.session
  return new Date(`${date}T${time}`)
})
const recipients = computed(() => {
  if (includeOnHold.value) {
    return orderedRecipients.value
  } else {
    return orderedRecipients.value.filter((r) => r.status !== "on_hold")
  }
})

function setOnHold(value: boolean) {
  includeOnHold.value = value
}

function print() {
  window.print()
}

function goBack() {
  router.go(-1)
}

sessionPlansStore.fetchPlanDetails(baseId, sessionId, date)
</script>

<template>
  <div class="page">
    <div class="field buttons is-pulled-right with-margins is-hidden-print">
      <p class="control">
        <CheckBox
          label="Include recipients that are on hold"
          :value="includeOnHold"
          @input="setOnHold"
        />
      </p>
      <p class="control">
        <button class="button is-primary" @click="goBack">
          Back to session
        </button>
      </p>
      <p class="control">
        <button class="button is-info is-hidden-print" @click="print">
          Print Descriptions
        </button>
      </p>
    </div>

    <h1 v-if="sessionDate" class="title with-margins">
      {{ formatDate(sessionDate, "EEEE h:mma") }}
    </h1>

    <div
      v-for="recipient in recipients"
      :key="recipient.id"
      class="recipient with-margins"
    >
      <h2 class="subtitle">{{ recipient.name }}</h2>
      <div class="is-multi-line">{{ recipient.description }}</div>
    </div>
  </div>
</template>

<style scoped>
.buttons {
  margin-top: 2rem;
}

.checkbox {
  font-size: 1rem;
}

.with-margins {
  margin-left: 2rem;
  margin-right: 2rem;
}

.page {
  overflow: visible;
  position: fixed;
  z-index: 999;
  height: 100%;
  width: 100%;
  left: 0;
  top: 0;
  background-color: white;
  font-size: 16px;
  color: black;
  overflow-y: auto;
}

.title {
  margin-top: 2rem;
  font-size: 24px;
  color: black;
}

.subtitle {
  margin-top: 35px;
  margin-bottom: 5px !important;
  font-weight: 600;
  font-size: 18px;
  color: black;
}
</style>
