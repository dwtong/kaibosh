<script lang="ts" setup>
import ModalCard from "@/components/ui/ModalCard.vue"
import { computed, reactive, ref } from "vue"
import SessionSelect from "../ui/SessionSelect.vue"
import {
  createRecipientSession,
  type RecipientSession,
} from "@/api/recipient-sessions"
import AllocationQuantitiesInput from "./AllocationQuantitiesInput.vue"
import { useAppStore } from "@/stores/app"
import { storeToRefs } from "pinia"
import { toast } from "@/utils/toast"
import { useRecipientSessionsStore } from "@/stores/recipient-sessions"

const props = defineProps<{
  recipientSessions?: RecipientSession[]
  recipientId: string
}>()
const isOpen = ref(false) // TODO: false
const selectedSessionId = ref()
const session = computed(() => {
  return props.recipientSessions?.find(
    (rs) => rs.sessionId == selectedSessionId.value,
  )
})
const sessionExists = computed(() => !!session.value)
const appStore = useAppStore()
const recipientSessionsStore = useRecipientSessionsStore()
const { categories } = storeToRefs(appStore)
const allocationCategories = reactive(
  categories.value?.map(({ id }) => {
    return {
      enabled: !!session.value?.allocations.find((a) => a.categoryId === id),
      categoryId: id,
      quantity: "",
    }
  }) || [],
)

function onClose() {
  isOpen.value = false
}

async function onSubmit() {
  const allocations = allocationCategories
    .filter((a) => a.enabled)
    .map(({ categoryId, quantity }) => {
      return { categoryId, quantity }
    })
  const sessionParams = {
    allocations,
    sessionId: selectedSessionId.value,
    recipientId: props.recipientId,
  }
  try {
    await createRecipientSession(props.recipientId, sessionParams)
    await recipientSessionsStore.fetchRecipientSessions(props.recipientId)
    allocationCategories.forEach((c) => (c.enabled = false))
    selectedSessionId.value = ""
    isOpen.value = false
    toast({ message: "Session created", type: "is-success" })
  } catch (error) {
    console.error(error)
    toast({ message: "Failed to create session", type: "is-danger" })
  }
}

function openModal() {
  isOpen.value = true
}

function onAllocationInput(categoryId: string, enabled: boolean) {
  const index = allocationCategories.findIndex(
    (a) => a.categoryId === categoryId,
  )
  allocationCategories[index].enabled = enabled
}
</script>

<template>
  <slot :open="openModal"></slot>
  <ModalCard
    :is-open="isOpen"
    title="Add Sorting Session"
    submit-button="Save"
    :disable-submit="!selectedSessionId || sessionExists"
    @close="onClose"
    @submit="onSubmit"
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
