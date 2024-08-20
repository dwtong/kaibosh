<script lang="ts" setup>
import type { RecipientSession } from "@/api/recipient-sessions"
import { formatTime } from "@/utils/date"
import { capitalize } from "es-toolkit"
import HoldStatusTag from "../ui/HoldStatusTag.vue"
import { Transition, ref } from "vue"

defineProps<{
  session: RecipientSession
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
          <div class="content">TODO: food allocations</div>
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
