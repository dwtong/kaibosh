<script lang="ts" setup>
import type { SessionAllocation } from "@/api/recipient-sessions"
import { useAppStore } from "@/stores/app"
import { quantityLabel } from "@/utils/allocations"
import { sortBy } from "es-toolkit"
import { computed } from "vue"

const appStore = useAppStore()

const props = defineProps<{
  allocations: SessionAllocation[]
}>()

const sortedAllocations = computed(() => {
  const allocations = props.allocations.map((allocation) => {
    return {
      id: allocation.id,
      quantityLabel: quantityLabel(allocation.quantity),
      category: appStore.getCategoryName(allocation.categoryId),
    }
  })
  return sortBy(allocations, ["category"])
})
</script>

<template>
  <table>
    <tr
      v-for="allocation in sortedAllocations"
      :key="allocation.id"
      :allocation="allocation"
    >
      <td>{{ allocation.category }}</td>
      <td>{{ allocation.quantityLabel }}</td>
    </tr>
  </table>
</template>
