<script setup lang="ts">
import { useRecipientsStore } from "@/stores/recipients"
import CheckBox from "../ui/CheckBox.vue"

const recipientStore = useRecipientsStore()
</script>

<template>
  <CheckBox
    v-for="filter in recipientStore.filteredStatus"
    :key="filter.name"
    :value="filter.enabled"
    :label="filter.label"
    @input="(value) => recipientStore.setFilteredStatus(filter.name, value)"
  />
</template>
