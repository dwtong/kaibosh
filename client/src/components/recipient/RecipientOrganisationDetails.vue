<script setup lang="ts">
import InfoField from "@/components/ui/InfoField.vue"
import type { Recipient } from "@/api/recipients"
import RecipientStatusTag from "./RecipientStatusTag.vue"
import { computed } from "vue"
import { formatDate } from "@/utils/date"

const props = defineProps<{
  recipient?: Recipient
}>()

const startDate = computed(() => {
  const date = props.recipient?.startedAt
  return date ? formatDate(new Date(date)) : null
})
</script>

<template>
  <div class="box">
    <h2 class="title is-4">Organisation Details</h2>
    <RecipientStatusTag
      :status="recipient?.status"
      size="is-medium"
      :with-label="true"
    />
    <InfoField label="Full Legal Name">
      {{ recipient?.name }}
    </InfoField>
    <InfoField label="Base">
      {{ recipient?.baseId }}
    </InfoField>
    <InfoField label="Physical Address">
      {{ recipient?.physicalAddress }}
    </InfoField>
    <InfoField label="Start Date">
      {{ startDate }}
    </InfoField>
    <InfoField label="description">
      <span class="is-multi-line">{{ recipient?.description }}</span>
    </InfoField>
  </div>
</template>
