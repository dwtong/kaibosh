<script lang="ts" setup>
import { addWeeks, formatDate, subWeeks } from "@/utils/date"
import { computed } from "vue"
import { useRouter } from "vue-router"
import WeekDatePicker from "../ui/WeekDatePicker.vue"

const props = defineProps<{
  date: Date
}>()
const router = useRouter()
const nextWeek = computed(() => addWeeks(props.date, 1))
const previousWeek = computed(() => subWeeks(props.date, 1))

function goToDate(value: Date) {
  const date = formatDate(value, "yyyy-MM-dd")
  router.push({ path: "/sessions/week", query: { date } })
}
</script>

<template>
  <div class="is-pulled-right field has-addons">
    <p class="control">
      <button
        class="button"
        title="Previous Week"
        @click="goToDate(previousWeek)"
      >
        <span class="icon is-small">
          <i class="fas fa-arrow-left"></i>
        </span>
      </button>
    </p>

    <p class="control">
      <WeekDatePicker :value="date" @input="goToDate($event)" />
    </p>

    <p class="control">
      <button class="button" title="Next Week" @click="goToDate(nextWeek)">
        <span class="icon is-small">
          <i class="fas fa-arrow-right"></i>
        </span>
      </button>
    </p>
  </div>
</template>
