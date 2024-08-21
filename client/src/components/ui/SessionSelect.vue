<script lang="ts" setup>
import { useSessionsStore } from "@/stores/sessions"
import { formatTime } from "@/utils/date"
import { capitalize } from "es-toolkit"
import { storeToRefs } from "pinia"

const sessionsStore = useSessionsStore()
const { sessions } = storeToRefs(sessionsStore)
const model = defineModel()

function updateSessionId(event: Event) {
  const { value } = event.target as HTMLInputElement
  model.value = value
}
</script>

<template>
  <div class="select">
    <select :value="model" @change="updateSessionId">
      <option class="placeholder" value="" disabled selected></option>
      <option v-for="session in sessions" :key="session.id" :value="session.id">
        {{ capitalize(session.day) }} {{ formatTime(session.time) }}
      </option>
    </select>
  </div>
</template>
