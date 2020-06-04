<template>
  <div>
    <div class="filter-box">
      <p class="subtitle">Filter By Base</p>
      <RecipientsBaseFilter />
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Name</p>
      <RecipientsNameFilter />
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Status</p>
      <RecipientsStatusFilter />
    </div>

    <a @click="resetFilters" id="reset-filter-link">Reset Filters</a>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import AllRecipients from "@/store/modules/all-recipients";
import RecipientsBaseFilter from "@/components/recipients/RecipientsBaseFilter.vue";
import RecipientsNameFilter from "@/components/recipients/RecipientsNameFilter.vue";
import RecipientsStatusFilter from "@/components/recipients/RecipientsStatusFilter.vue";

@Component({ components: { RecipientsBaseFilter, RecipientsNameFilter, RecipientsStatusFilter } })
export default class RecipientsFilterPanel extends Vue {
  resetFilters() {
    AllRecipients.resetFilters();
  }
}
</script>

<style lang="scss" scoped>
.filter-box {
  margin-bottom: 2.5rem;

  .subtitle {
    margin-left: 0.1rem;
  }
}

#reset-filter-link {
  font-size: 0.85rem;
  margin-left: 0.1rem;
}
</style>
