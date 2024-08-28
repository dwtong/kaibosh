<script setup lang="ts">
import { computed, onMounted, ref } from "vue"
import { Datepicker } from "vanillajs-datepicker"
import { dateOnDayOfWeek } from "@/utils/date"

const props = defineProps<{
  value?: Date
}>()
const emits = defineEmits<{
  (e: "input", value: Date): void
}>()
let datepicker: Datepicker
const showDatePicker = ref(false)
const label = computed(() => {
  let date = props.value || new Date()
  let start = dateOnDayOfWeek(date, "Monday")
  let end = dateOnDayOfWeek(date, "Sunday")
  let startMonth = start.toLocaleString("default", { month: "long" })
  let endMonth = end.toLocaleString("default", { month: "long" })
  return `${start.getDate()} ${startMonth} - ${end.getDate()} ${endMonth} ${end.getFullYear()}`
})

onMounted(() => {
  const element = document.getElementById("week-date-picker") as HTMLElement
  datepicker = new Datepicker(element, {
    autohide: true,
    todayButton: true,
    todayButtonMode: 1,
    format: "dd/mm/yyyy",
  })
  element.addEventListener("changeDate", (ev) => {
    const { date } = (ev as CustomEvent).detail
    onInput(date || null)
  })
  datepicker.setDate(props.value)
})

function onInput(date: Date) {
  showDatePicker.value = false
  datepicker.setDate(date)
  emits("input", date)
}
</script>

<template>
  <div v-click-outside-element="() => (showDatePicker = false)">
    <div class="field">
      <div class="control">
        <button
          class="button"
          @click="() => (showDatePicker = !showDatePicker)"
        >
          {{ label }}
        </button>
      </div>
    </div>
    <div
      id="week-date-picker"
      :class="{ hidden: !showDatePicker }"
      data-date="01/25/2020"
    ></div>
  </div>
</template>

<style scoped>
.button {
  width: 100%;
}
.error-msg {
  font-size: 0.8rem;
  color: red;
}
.hidden {
  visibility: hidden;
}
</style>
