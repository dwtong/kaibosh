<template>
  <div>
    <div class="filter-box">
      <p class="subtitle">Filter By Name</p>
      <div class="field">
        <div class="control">
          <input
            id="name-filter"
            @input="updateNameFilter($event.target.value)"
            type="text"
            class="input"
            placeholder="Recipient Name"
            :value="filters.name"
          />
        </div>
      </div>
    </div>

    <div class="filter-box">
      <p class="subtitle">Filter By Status</p>
      <div v-for="filter in filters.status" :key="filter.name" class="field">
        <b-checkbox
          @input="toggleStatusFilter(filter.name)"
          :name="filter.name"
          type="is-info"
          :value="filter.enabled"
          >{{ filter.label }}</b-checkbox
        >
      </div>
    </div>

    <a @click="resetFilters" class="reset-filter-link">Reset Filters</a>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";

export default {
  computed: {
    ...mapState("recipients", ["filters"])
  },

  methods: {
    ...mapActions("recipients", [
      "updateNameFilter",
      "toggleStatusFilter",
      "resetFilters"
    ])
  }
};
</script>

<style lang="scss" scoped>
.filter-box {
  margin-bottom: 2.5rem;

  .subtitle {
    margin-left: 0.1rem;
  }
}

.reset-filter-link {
  font-size: 0.85rem;
  margin-left: 0.1rem;
}
</style>
