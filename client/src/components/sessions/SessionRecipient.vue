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
