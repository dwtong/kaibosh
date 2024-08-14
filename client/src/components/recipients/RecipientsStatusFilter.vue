<script setup lang="ts">
import { useRecipientsStore } from "@/stores/recipients"
import CheckBox from "../ui/CheckBox.vue"

const recipientStore = useRecipientsStore()
</script>

<template>
  <div>
    <div v-for="filter in recipientStore.filteredStatus" :key="filter.name">
      <CheckBox
        :value="filter.enabled"
        :label="filter.label"
        @input="(value) => recipientStore.setFilteredStatus(filter.name, value)"
      />
    </div>
  </div>
</template>
