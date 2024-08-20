<script lang="ts" setup>
import type { SessionHold } from "@/api/recipient-sessions"
import { computed } from "vue"
import { sortBy } from "es-toolkit"
import { formatDate } from "@/utils/date"

const props = defineProps<{
  holds: SessionHold[]
  deleteHold: (holdId: string) => void
}>()

const sortedHolds = computed(() => sortBy(props.holds, ["startsAt"]))
</script>

<template>
  <table>
    <tbody>
      <tr v-for="hold in sortedHolds" :key="hold.id">
        <td v-if="hold.endsAt">
          {{ formatDate(hold.startsAt) }} - {{ formatDate(hold.endsAt) }}
        </td>
        <td v-else>{{ formatDate(hold.startsAt) }} - (no end date)</td>
        <td>
          <a class="delete is-medium" @click="deleteHold(hold.id)"></a>
        </td>
      </tr>
    </tbody>
  </table>
</template>
