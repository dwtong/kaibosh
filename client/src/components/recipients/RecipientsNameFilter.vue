<script setup lang="ts">
import { useRecipientsStore } from '@/stores/recipients'

const recipientStore = useRecipientsStore()

function updateNameFilter(event: Event) {
  const { value } = event.target as HTMLInputElement
  recipientStore.setFilteredName(value)
}
</script>

<template>
  <div class="field">
    <div class="control">
      <input
        id="name-filter"
        :value="recipientStore.filteredName"
        type="text"
        class="input"
        placeholder="Recipient Name"
        @input="updateNameFilter"
      />
    </div>
  </div>
</template>
