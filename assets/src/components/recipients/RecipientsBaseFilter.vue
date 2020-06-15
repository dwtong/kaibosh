<template>
  <BaseSelect :value="filteredBase" all="true" @input="updateBaseFilter($event)" />
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import AllRecipients from "@/store/modules/all-recipients";
import BaseSelect from "@/components/ui/BaseSelect.vue";

@Component({ components: { BaseSelect } })
export default class RecipientsBaseFilter extends Vue {
  get filteredBase(): string {
    return AllRecipients.filteredBase;
  }

  updateBaseFilter(baseId: string): void {
    AllRecipients.updateBaseFilter(baseId);
  }
}
</script>
