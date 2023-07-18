<script setup lang="ts">
import { useRecipientsStore } from '@/stores/recipients'
import RecipientsBaseFilter from './RecipientsBaseFilter.vue'
import RecipientsNameFilter from './RecipientsNameFilter.vue'
import RecipientsStatusFilter from './RecipientsStatusFilter.vue'
import { exportRecipients } from '@/api/recipients'

const recipientStore = useRecipientsStore()
const resetFilters = recipientStore.resetFilters

async function downloadCsv() {
  const params = {
    baseId: recipientStore.filteredBase,
    name: recipientStore.filteredName,
    status: ['active'],
  }
  const csv = await exportRecipients(params)
  const blob = new Blob([csv], { type: 'text/csv' })
  const link = document.createElement('a')
  link.href = URL.createObjectURL(blob)
  link.download = 'recipients.csv'
  link.click()
  URL.revokeObjectURL(link.href)
}
</script>

<template>
  <div>
    <div class="filter-box">
      <p class="subtitle">Filter By Base</p>
      <RecipientsBaseFilter />
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Name</p>
      <RecipientsNameFilter />
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Status</p>
      <RecipientsStatusFilter />
    </div>

    <a class="filter-link" @click="resetFilters">Reset Filters</a>
    <a class="filter-link" @click="downloadCsv">Download CSV</a>
  </div>
</template>

<style lang="scss" scoped>
.filter-box {
  margin-bottom: 2.5rem;

  .subtitle {
    margin-left: 0.1rem;
  }
}

.filter-link {
  display: block;
  font-size: 0.85rem;
  margin-left: 0.1rem;
  margin-bottom: 1.2rem;
}
</style>
