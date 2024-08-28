<script setup lang="ts">
import { useAppStore } from "@/stores/app"

type Props = {
  value: string
  all?: boolean
  required?: boolean
  label?: string
  help?: string
  placeholder?: string
}

withDefaults(defineProps<Props>(), {
  all: false,
  required: false,
  label: "",
  help: "",
  placeholder: "",
})

defineEmits<{
  (e: "input", event: Event): void
}>()

const appStore = useAppStore()
appStore.fetchBases()
</script>

<template>
  <div class="select">
    <select
      :value="value"
      :placeholder="placeholder"
      @change="(e) => $emit('input', e)"
    >
      <option v-if="placeholder" class="placeholder" value="" disabled selected>
        {{ placeholder }}
      </option>
      <option v-if="all" :value="0">All</option>
      <option v-for="base in appStore.bases" :key="base.id" :value="base.id">
        {{ base.name }}
      </option>
    </select>
  </div>
</template>

<style scoped>
.placeholder {
  color: hsl(0deg 0% 78.04%);
}
</style>
