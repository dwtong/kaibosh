<script setup lang="ts">
import type { Recipient } from "@/api/recipients"
import CheckBox from "@/components/ui/CheckBox.vue"

defineProps<{
  recipient?: Recipient
}>()

defineEmits<{
  (e: "input", name: string, value: boolean): void
}>()
</script>

<template>
  <div class="box">
    <h2 class="title is-4">Onboarding</h2>
    <div class="field">
      <CheckBox
        label="Terms and conditions are signed"
        name="hasSignedTerms"
        :value="!!recipient?.hasSignedTerms"
        @input="(value) => $emit('input', 'hasSignedTerms', value)"
      />
    </div>
    <div class="field">
      <CheckBox
        label="Have met Kaibosh in person"
        name="hasMetKaibosh"
        :value="!!recipient?.hasMetKaibosh"
        @input="(value) => $emit('input', 'hasMetKaibosh', value)"
      />
    </div>
  </div>
</template>
