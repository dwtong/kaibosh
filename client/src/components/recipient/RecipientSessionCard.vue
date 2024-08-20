<script lang="ts" setup>
import { destroyHold, type RecipientSession } from "@/api/recipient-sessions"
import { formatTime } from "@/utils/date"
import { capitalize } from "es-toolkit"
import HoldStatusTag from "../ui/HoldStatusTag.vue"
import { Transition, ref } from "vue"
import HoldsList from "./HoldsList.vue"
import { useRecipientSessionsStore } from "@/stores/recipient-sessions"
import { toast } from "@/utils/toast"
import { useRoute } from "vue-router"

const props = defineProps<{
  session: RecipientSession
  deleteHold: (holdId: string) => void
  deleteSession: (sessionId: string) => void
  updateSession: (session: RecipientSession) => void
}>()

const recipientSessionsStore = useRecipientSessionsStore()
const expanded = ref(true) // TODO: false
const route = useRoute()

function toggleExpanded() {
  expanded.value = !expanded.value
}

async function removeHold(holdId: string) {}
</script>

<template>
  <div class="card">
    <header class="card-header level" @click="toggleExpanded">
      <div class="level-left">
        <div class="level-item">
          <p class="card-header-title">
            <span class="has-text-weight-semibold is-size-5 day-text">{{
              capitalize(session.day)
            }}</span>
            <span class="has-text-weight-normal is-size-5">{{
              formatTime(session.time)
            }}</span>
          </p>
        </div>
      </div>
      <div class="level-left">
        <div class="level-item hold-status">
          <HoldStatusTag :status="session.status" />
        </div>
      </div>
    </header>
    <Transition>
      <div v-if="expanded">
        <div class="card-content">
          <div v-if="session.holds.length > 0" class="content">
            <p class="label">Session Holds</p>
            <HoldsList :holds="session.holds" :delete-hold="deleteHold" />
          </div>
          <div class="content">
            <p class="label">Food Allocations</p>
            <!-- <AllocationList :allocations="recipientSession.allocations" /> -->
          </div>
        </div>
        <footer v-if="expanded" class="card-footer">
          <a href="#" class="card-footer-item">Edit</a>
          <a href="#" class="card-footer-item">Delete</a>
        </footer>
      </div>
    </Transition>
  </div>
</template>

<style>
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

.v-enter-active,
.v-leave-active {
  transition: opacity 0.1s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}
</style>
