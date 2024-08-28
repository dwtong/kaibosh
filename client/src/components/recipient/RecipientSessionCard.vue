<script lang="ts" setup>
import { type RecipientSession } from "@/api/recipient-sessions"
import { formatTime } from "@/utils/date"
import { capitalize } from "es-toolkit"
import HoldStatusTag from "../ui/HoldStatusTag.vue"
import { ref } from "vue"
import HoldsList from "./HoldsList.vue"
import AllocationList from "./AllocationList.vue"

defineProps<{
  recipientSession: RecipientSession
  deleteHold: (holdId: string) => void
  openDeleteModal: (recipientSessionId: string) => void
  openUpdateModal: (recipientSessionId: string) => void
}>()

const expanded = ref(false)

function toggleExpanded() {
  expanded.value = !expanded.value
}
</script>

<template>
  <div class="card">
    <header class="card-header level" @click="toggleExpanded">
      <div class="level-left">
        <div class="level-item">
          <p class="card-header-title">
            <span class="has-text-weight-semibold is-size-5 day-text">{{
              capitalize(recipientSession.day)
            }}</span>
            <span class="has-text-weight-normal is-size-5">{{
              formatTime(recipientSession.time)
            }}</span>
          </p>
        </div>
      </div>
      <div class="level-left">
        <div class="level-item hold-status">
          <HoldStatusTag :status="recipientSession.status" />
        </div>
      </div>
    </header>
    <Transition>
      <div v-if="expanded">
        <div class="card-content">
          <div v-if="recipientSession.holds.length > 0" class="content">
            <p class="label">Session Holds</p>
            <HoldsList
              :holds="recipientSession.holds"
              :delete-hold="deleteHold"
            />
          </div>
          <div class="content">
            <p class="label">Food Allocations</p>
            <AllocationList :allocations="recipientSession.allocations" />
          </div>
        </div>
        <footer v-if="expanded" class="card-footer">
          <a
            class="card-footer-item"
            @click="() => openUpdateModal(recipientSession.id)"
          >
            Edit
          </a>
          <a
            class="card-footer-item"
            @click="() => openDeleteModal(recipientSession.id)"
          >
            Delete
          </a>
        </footer>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.card {
  margin-bottom: 1rem;
  cursor: pointer;
}

.card-header {
  background-color: #e6e6e6;
}

.content {
  margin-bottom: 2.5rem !important;
}

.day-text {
  margin-right: 0.5rem;
}

.hold-status {
  margin-right: 0.5rem;
}
</style>
