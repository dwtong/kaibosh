<script setup lang="ts">
import type { RecipientSummary } from "@/api/recipients"
import RecipientStatusTag from "../recipient/RecipientStatusTag.vue"
import { useRouter } from "vue-router"
import { useRecipientsStore } from "@/stores/recipients"
import SortIcon from "../ui/SortIcon.vue"
import { storeToRefs } from "pinia"

const router = useRouter()
const recipientStore = useRecipientsStore()
const { sortDir, sortField } = storeToRefs(recipientStore)
const sortBy = recipientStore.setSort

const props = defineProps<{
  recipients: RecipientSummary[]
}>()

function navigate(recipientId: string): void {
  router.push(`/recipients/${recipientId}`)
}
</script>

<template>
  <table class="table is-fullwidth is-hoverable is-striped">
    <thead>
      <th @click="sortBy('name')">
        <div>
          Name
          <SortIcon v-if="sortField === 'name'" :direction="sortDir" />
        </div>
      </th>
      <th class="th-status" @click="sortBy('status')">
        Status
        <SortIcon v-if="sortField === 'status'" :direction="sortDir" />
      </th>
    </thead>
    <tbody>
      <tr
        v-for="recipient in props.recipients"
        :key="recipient.id"
        @click="navigate(recipient.id)"
      >
        <td>{{ recipient.name }}</td>
        <td><RecipientStatusTag :status="recipient.status" /></td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped lang="scss">
.table th {
  cursor: pointer;
  font-size: 0.8rem;
  letter-spacing: 0.1rem;
  padding: 0.5em 0;
  text-transform: uppercase;
}

.table tr {
  cursor: pointer;
}

.th-status {
  width: 100px;
  text-align: right;
}
</style>
