<script setup lang="ts">
import { useRecipientsStore } from "@/stores/recipients"
import BaseSelect from "../ui/BaseSelect.vue"

const recipientStore = useRecipientsStore()

function updateBaseFilter(event: Event) {
  const { value } = event.target as HTMLInputElement
  recipientStore.setFilteredBase(parseInt(value))
}
</script>

<template>
  <div>
    <BaseSelect
      :value="recipientStore.filteredBase"
      :all="true"
      @input="updateBaseFilter"
    />
  </div>
</template>
