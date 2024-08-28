<script lang="ts" setup>
import type { Contact } from "@/api/recipients"
import InfoField from "../ui/InfoField.vue"

defineProps<{
  contact?: Contact
}>()
</script>

<template>
  <div class="box">
    <h2 class="title is-4">Primary Contact</h2>

    <InfoField label="Name">
      {{ contact?.name }}
    </InfoField>
    <InfoField label="Email">
      {{ contact?.email }}
    </InfoField>
    <InfoField label="Mobile">
      {{ contact?.phoneMobile }}
    </InfoField>
    <InfoField label="Landline">
      {{ contact?.phoneLandline }}
    </InfoField>
  </div>
</template>
