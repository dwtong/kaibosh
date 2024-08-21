<script lang="ts" setup>
import ModalCard from "@/components/ui/ModalCard.vue"
import { computed, ref } from "vue"
import SessionSelect from "../ui/SessionSelect.vue"
import type { RecipientSession } from "@/api/recipient-sessions"

const props = defineProps<{
  recipientSessions?: RecipientSession[]
}>()
const isOpen = ref(false) // TODO: false
const selectedSessionId = ref()
const sessionExists = computed(() => {
  return !!props.recipientSessions?.find(
    (rs) => rs.sessionId == selectedSessionId.value,
  )
})

function onClose() {
  isOpen.value = false
}

function openModal() {
  isOpen.value = true
}
</script>

<template>
  <slot :open="openModal"></slot>
  <ModalCard
    :is-open="isOpen"
    title="Add Sorting Session"
    success-button="Save"
    :disable-success="!selectedSessionId || sessionExists"
    @close="onClose"
  >
    <div class="columns">
      <div class="column">
        <p class="subtitle">Select session time and day</p>
        <SessionSelect v-model="selectedSessionId" />
        <p v-if="sessionExists" class="error-msg">
          Selected session already exists.
        </p>
      </div>
    </div>

    <div v-if="selectedSessionId && !sessionExists" class="columns">
      <div class="column">
        <p class="subtitle">Choose category quantities</p>
        <!-- <AllocationQuantitiesInput v-model="allocations" :base-id="baseId" /> -->
      </div>
    </div>
  </ModalCard>
</template>

<style scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
