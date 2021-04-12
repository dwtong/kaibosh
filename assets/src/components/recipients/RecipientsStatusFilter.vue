<template>
  <div>
    <div v-for="filter in filteredStatus" :id="filter.name + '-filter'" :key="filter.name" class="field">
      <b-checkbox :name="filter.name" :value="filter.enabled" type="is-info" @input="toggleStatusFilter(filter.name)">{{
        filter.label
      }}</b-checkbox>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import AllRecipients from "@/store/modules/all-recipients";
import { IStatus } from "@/types";

export default defineComponent({
  computed: {
    filteredStatus(): IStatus[] {
      return AllRecipients.filteredStatus;
    }
  },
  methods: {
    toggleStatusFilter(name: string): void {
      AllRecipients.toggleStatusFilter(name);
    }
  }
});
</script>
