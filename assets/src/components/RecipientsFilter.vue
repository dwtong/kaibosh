<template>
  <div>
    <div class="filter-box">
      <p class="subtitle">Filter By Base</p>
      <BaseSelect
        @input="updateBaseFilter($event)"
        :value="filteredBase"
        all="true"
      />
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Name</p>
      <div class="field">
        <div class="control">
          <input
            @input="updateNameFilter($event.target.value)"
            :value="filteredName"
            id="name-filter"
            type="text"
            class="input"
            placeholder="Recipient Name"
          />
        </div>
      </div>
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Status</p>
      <div
        v-for="filter in filteredStatus"
        :key="filter.name"
        :id="filter.name + '-filter'"
        class="field"
      >
        <b-checkbox
          @input="toggleStatusFilter(filter.name)"
          :name="filter.name"
          :value="filter.enabled"
          type="is-info"
          >{{ filter.label }}</b-checkbox
        >
      </div>
    </div>

    <a @click="resetFilters" id="reset-filter-link">Reset Filters</a>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import BaseSelect from "@/components/form/BaseSelect.vue";
import { AllRecipientsModule } from "@/store/modules/all-recipients";
import { IStatus } from "@/types";

@Component({ components: { BaseSelect } })
export default class RecipientsFilter extends Vue {
  get filteredBase(): string {
    return AllRecipientsModule.filteredBase;
  }

  get filteredName(): string {
    return AllRecipientsModule.filteredName;
  }

  get filteredStatus(): IStatus[] {
    return AllRecipientsModule.filteredStatus;
  }

  updateBaseFilter(baseId: string) {
    AllRecipientsModule.updateBaseFilter(baseId);
    localStorage.setItem("baseId", baseId);
  }

  updateNameFilter(name: string) {
    AllRecipientsModule.updateNameFilter(name);
  }

  toggleStatusFilter(name: string) {
    AllRecipientsModule.toggleStatusFilter(name);
  }

  resetFilters() {
    AllRecipientsModule.resetFilters();
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
