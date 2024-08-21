<script setup lang="ts">
defineProps<{
  disabled: boolean
}>()
const quantities = [
  { value: "", name: "No limit" },
  { value: "0.5", name: "1/2" },
  { value: "1.0", name: "1" },
  { value: "2.0", name: "2" },
  { value: "3.0", name: "3" },
  { value: "4.0", name: "4" },
  { value: "5.0", name: "5" },
  { value: "6.0", name: "6" },
  { value: "7.0", name: "7" },
  { value: "8.0", name: "8" },
  { value: "9.0", name: "9" },
  { value: "10.0", name: "10" },
]
const model = defineModel()

function updateQuantity(event: Event) {
  const { value } = event.target as HTMLInputElement
  model.value = value
}
</script>

<template>
  <div class="select">
    <select :value="model" :disabled="disabled" @change="updateQuantity">
      <option
        v-for="quantity in quantities"
        :key="quantity.name"
        :value="quantity.value"
      >
        {{ disabled ? "" : quantity.name }}
      </option>
    </select>
  </div>
</template>

<style scoped>
.select {
  width: 7rem;
}
</style>
