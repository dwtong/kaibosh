<script setup lang="ts">
import { computed } from 'vue'

type Props = {
  status: string
  size: 'is-normal' | 'is-medium' | 'is-large'
  withLabel: boolean
}

const props = withDefaults(defineProps<Props>(), {
  status: 'is-primary',
  size: 'is-normal',
  withLabel: false,
})

const label = computed(() => props.status?.replace('_', ' '))
const type = computed(() => {
  const typeKey = props.status as keyof typeof types
  const types = {
    on_hold: 'is-warning',
    active: 'is-primary',
    archived: 'is-gray-darker',
    pending: 'is-info',
  }

  return types[typeKey] || 'is-gray-darker'
})
</script>

<template>
  <div>
    <div v-if="props.withLabel" class="field">
      <label class="label">Status</label>
      <transition name="fade">
        <span class="tag" :class="type" :size="props.size">{{ label }}</span>
      </transition>
    </div>
    <span v-else class="tag" :class="type" :size="props.size">{{ label }}</span>
  </div>
</template>

<style scoped lang="scss">
.tag {
  border-radius: 1rem;
}
</style>
