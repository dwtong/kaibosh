<script lang="ts" setup>
import ModalCard from "@/components/ui/ModalCard.vue"
import { computed, reactive, ref } from "vue"
import SessionSelect from "../ui/SessionSelect.vue"
import {
  type RecipientSession,
  type RecipientSessionParams,
} from "@/api/recipient-sessions"
import AllocationQuantitiesInput from "./AllocationQuantitiesInput.vue"
import { useAppStore } from "@/stores/app"
import { storeToRefs } from "pinia"

const props = defineProps<{
  recipientSessions?: RecipientSession[]
  recipientId: string
  existingSession?: RecipientSession
}>()
const emit = defineEmits<{
  (e: "close"): void
  (e: "submit", sessionParams: RecipientSessionParams): void
}>()
const isOpen = ref(false)
const session = computed(() => {
  return props.recipientSessions?.find(
    (rs) => rs.sessionId == selectedSessionId.value,
  )
})
const selectedSessionId = ref()
const sessionExists = computed(() => !!session.value)
const appStore = useAppStore()
const { categories } = storeToRefs(appStore)
const allocationCategories = reactive(
  categories.value?.map(({ id: categoryId }) => {
    const allocations = props.existingSession?.allocations
    const allocation = allocations?.find((a) => a.categoryId == categoryId)
    return {
      categoryId,
      quantity: allocation ? allocation.quantity : "",
      enabled: !!allocation,
    }
  }) || [],
)
const title = computed(() => {
  return props.existingSession ? "Edit Sorting Session" : "Add Sorting Session"
})

async function onSubmit() {
  const allocations = allocationCategories
    .filter((a) => a.enabled)
    .map(({ categoryId, quantity }) => {
      return { categoryId, quantity }
    })
  const sessionParams = {
    allocations,
    sessionId: selectedSessionId.value as string,
    recipientId: props.recipientId,
  }
  emit("submit", sessionParams)
  allocationCategories.forEach((c) => (c.enabled = false))
  selectedSessionId.value = undefined
  isOpen.value = false
}

function onAllocationInput(categoryId: string, enabled: boolean) {
  const index = allocationCategories.findIndex(
    (a) => a.categoryId === categoryId,
  )
  allocationCategories[index].enabled = enabled
}

function openModal() {
  isOpen.value = true
}
</script>

<template>
  <slot :open="openModal"></slot>
  <ModalCard
    :is-open="isOpen"
    :title="title"
    submit-button="Save"
    :disable-submit="!existingSession && (!selectedSessionId || sessionExists)"
    @close="() => (isOpen = false)"
    @submit="onSubmit"
  >
    <div class="columns">
      <div v-if="!existingSession" class="column">
        <p class="subtitle">Select session time and day</p>
        <SessionSelect v-model="selectedSessionId" />
        <p v-if="sessionExists" class="error-msg">
          Selected session already exists.
        </p>
      </div>
    </div>

    <div
      v-if="(existingSession || selectedSessionId) && !sessionExists"
      class="columns"
    >
      <div class="column">
        <p class="subtitle">Choose category quantities</p>
        <AllocationQuantitiesInput
          :allocations="allocationCategories"
          @input="onAllocationInput"
        />
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
