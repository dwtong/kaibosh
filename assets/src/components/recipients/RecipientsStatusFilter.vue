<template>
  <div>
    <div v-for="filter in filteredStatus" :key="filter.name" :id="filter.name + '-filter'" class="field">
      <b-checkbox @input="toggleStatusFilter(filter.name)" :name="filter.name" :value="filter.enabled" type="is-info">{{
        filter.label
      }}</b-checkbox>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import AllRecipients from "@/store/modules/all-recipients";
import { IStatus } from "@/types";

@Component
export default class RecipientsBaseFilter extends Vue {
  get filteredStatus(): IStatus[] {
    return AllRecipients.filteredStatus;
  }
  toggleStatusFilter(name: string) {
    AllRecipients.toggleStatusFilter(name);
  }
}
</script>
