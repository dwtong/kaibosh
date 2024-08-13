<script setup lang="ts">
import { useAppStore } from "@/stores/app"

type Props = {
  all?: boolean
  required?: boolean
  label?: string
  help?: string
  value: string
}

withDefaults(defineProps<Props>(), {
  all: false,
  required: false,
  label: "",
  help: "",
})

defineEmits<{
  (e: "input", event: Event): void
}>()

const appStore = useAppStore()
appStore.fetchBases()
</script>

<template>
  <div class="select">
    <select :value="value" @change="(e) => $emit('input', e)">
      <option v-if="all" :value="0">All</option>
      <option v-for="base in appStore.bases" :key="base.id" :value="base.id">
        {{ base.name }}
      </option>
    </select>
  </div>
</template>
