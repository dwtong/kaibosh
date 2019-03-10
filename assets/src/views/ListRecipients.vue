<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <button class="button is-primary is-pulled-right">
        Create Recipient
      </button>
    </div>

    <div class="columns">
      <div class="column">
        <div class="box">
          <RecipientsTable :data="filteredRecipients" />
        </div>
      </div>

      <div class="column is-one-quarter">
        <div class="box">
          <div class="filter-box">
            <p class="subtitle">Filter By Name</p>
            <div class="field">
              <div class="control">
                <input
                  v-model="nameFilter"
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
              v-for="filter in statusFilters"
              :key="filter.name"
              class="field"
            >
              <b-checkbox v-model="filter.enabled" type="is-info">{{
                filter.label
              }}</b-checkbox>
            </div>
          </div>

          <a @click="resetFilters" class="reset-filter-link">Reset Filters</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import RecipientsTable from "@/components/RecipientsTable";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    RecipientsTable
  },

  computed: {
    ...mapGetters(["recipients"]),
    filteredRecipients() {
      const statusFilters = this.statusFilters.filter(filter => filter.enabled);
      const nameFilter = this.nameFilter.toLowerCase();

      return this.recipients.filter(recipient =>
        statusFilters.find(
          filter =>
            recipient.status === filter.name &&
            recipient.name.toLowerCase().includes(nameFilter)
        )
      );
    }
  },
  async created() {
    await this.getAllRecipients();
    this.loading = false;
  },

  data() {
    return {
      columns: [
        { field: "name", label: "Food Recipient Name" },
        { field: "status", label: "Status" }
      ],
      nameFilter: "",
      statusFilters: [
        { label: "Active", name: "active", enabled: true },
        { label: "Pending", name: "pending", enabled: true },
        { label: "On Hold", name: "on_hold", enabled: true },
        { label: "Archived", name: "archived", enabled: true }
      ],
      loading: true
    };
  },

  methods: {
    ...mapActions(["getAllRecipients"]),
    resetFilters() {
      this.nameFilter = "";
      this.statusFilters.forEach(f => (f.enabled = true));
    }
  }
};
</script>

<style lang="scss" scoped>
.button {
  margin-top: 0.3rem;
}

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

.title {
  margin-left: 0.5rem !important;
  margin-bottom: 2.5rem !important;
}

.title-box {
  margin-right: 0.5rem;
}
</style>
