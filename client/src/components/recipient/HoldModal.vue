<script lang="ts" setup>
import ModalCard from "@/components/ui/ModalCard.vue"
import { ref } from "vue"

const isOpen = ref(false)

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
    :disable-success="false"
    title="Add Hold"
    submit-button="Save"
    @close="onClose"
  />
</template>
