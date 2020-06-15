<template>
  <div class="field">
    <div class="control">
      <input
        id="name-filter"
        :value="filteredName"
        type="text"
        class="input"
        placeholder="Recipient Name"
        @input="updateNameFilter($event.target.value)"
      />
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import AllRecipients from "@/store/modules/all-recipients";

@Component
export default class RecipientsNameFilter extends Vue {
  get filteredName(): string {
    return AllRecipients.filteredName;
  }

  updateNameFilter(name: string): void {
    AllRecipients.updateNameFilter(name);
  }
}
</script>
