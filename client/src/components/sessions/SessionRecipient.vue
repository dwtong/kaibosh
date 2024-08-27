<script setup lang="ts">
import type { SessionRecipient } from "@/api/sessions"
import { quantityLabel } from "@/utils/allocations"
import { computed } from "vue"
import { useRouter } from "vue-router"

const props = defineProps<{
  recipient: SessionRecipient
  quantity?: string
}>()
const router = useRouter()
const onHold = computed(() => props.recipient.status === "on_hold")

function viewRecipient() {
  router.push(`/recipients/${props.recipient.id}`)
}
</script>

<template>
  <div>
    <div class="print-only" :class="{ inactive: onHold }">
      {{ recipient.name }}
      <span v-if="quantity && !onHold">
        <strong>({{ quantityLabel(quantity) }})</strong>
      </span>
    </div>
    <div class="is-hidden-print">
      <div class="allocation-recipient" @click="viewRecipient">
        <span v-if="quantity && !onHold" class="tag is-pulled-right is-rounded">
          {{ quantityLabel(quantity) }}
        </span>
        <span :class="{ inactive: onHold }" class="button is-text">
          {{ recipient.name }}
        </span>
      </div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.print-only {
  font-size: 12px;
}

.allocation-recipient {
  @media print {
    margin-bottom: 0.2rem;
    font-size: 12px !important;
  }

  .tag {
    font-weight: 800;
    margin-left: 0.1rem;
    margin-top: 0.4rem;
  }
}

.is-text {
  margin-bottom: 0rem !important;
  text-decoration: none !important;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis !important;
  display: block;
  text-align: left;
}

.inactive {
  text-decoration-line: line-through !important;
  color: darkgray !important;
}
</style>
