<script setup lang="ts">
import AllocationQuantitesSelect from "../ui/AllocationQuantitesSelect.vue"
import CheckBox from "../ui/CheckBox.vue"
import { useAppStore } from "@/stores/app"

export type AllocationInput = {
  enabled: boolean
  categoryId: string
  quantity: string
}

const { getCategoryName, getCategoryUnit } = useAppStore()

defineProps<{
  allocations: AllocationInput[]
}>()
defineEmits<{
  (e: "input", categoryId: string, enabled: boolean): void
}>()
</script>

<template>
  <div>
    <div v-for="allocation in allocations" :key="allocation.categoryId">
      <div class="level box" :class="{ disabled: allocation.enabled == false }">
        <div class="level-left">
          <div class="level-item">
            <CheckBox
              :label="getCategoryName(allocation.categoryId)"
              :value="allocation.enabled"
              @input="(value) => $emit('input', allocation.categoryId, value)"
            />
          </div>
        </div>
        <div class="level-right">
          <div class="level-item">
            <div class="field allocation-field has-addons">
              <p class="control">
                <AllocationQuantitesSelect
                  v-model="allocation.quantity"
                  :disabled="!allocation.enabled"
                />
              </p>
              <p class="control">
                <button class="button is-static">
                  {{ getCategoryUnit(allocation.categoryId) }} (max)
                </button>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.allocation-field {
  padding-top: 0.4rem;
  padding-bottom: 0;
  margin-bottom: 0;
}
.box {
  padding: 0 0 0 0.5rem;
}

.field {
  margin-bottom: 0;
}

.disabled {
  .category-label {
    color: gray;
  }
}

.category-label {
  margin-left: 0.5rem;
}

.category-quantity {
  width: 5rem;
}
</style>
