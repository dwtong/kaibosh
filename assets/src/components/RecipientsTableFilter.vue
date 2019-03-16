<template>
  <div>
    <div class="filter-box">
      <p class="subtitle">Filter By Name</p>
      <div class="field">
        <div class="control">
          <input
            @input="updateNameFilter($event.target.value)"
            :value="filters.name"
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
        v-for="filter in filters.status"
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

#reset-filter-link {
  font-size: 0.85rem;
  margin-left: 0.1rem;
}
</style>
