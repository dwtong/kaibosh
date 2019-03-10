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
          <b-table
            class="table"
            :data="filteredRecipients"
            hoverable
            striped
            default-sort-direction="asc"
            default-sort="name"
          >
            <template slot="empty">
              <section class="section">
                <div class="has-text-grey has-text-centered">
                  <p>
                    <b-icon
                      class="has-text-grey-lighter sad-icon"
                      icon="frown"
                      size="is-large"
                    >
                    </b-icon>
                  </p>
                  <p>Nothing here.</p>
                </div>
              </section>
            </template>

            <template slot-scope="props">
              <b-table-column field="name" label="Name" sortable>{{
                props.row.name
              }}</b-table-column>

              <b-table-column field="status" label="Status" centered sortable>
                <RecipientStatusTag :status="props.row.status" />
              </b-table-column>
            </template>
          </b-table>
        </div>
      </div>

      <div class="column is-one-quarter">
        <div class="box">
          <div class="filter-box">
            <p class="subtitle">Filters</p>
            <div v-for="filter in filters" :key="filter.name" class="field">
              <b-checkbox v-model="filter.enabled" type="is-info">{{
                filter.label
              }}</b-checkbox>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import RecipientStatusTag from "@/components/RecipientStatusTag";
import { mapActions, mapGetters } from "vuex";

export default {
  components: {
    RecipientStatusTag
  },

  computed: {
    ...mapGetters(["recipients"]),
    enabledFilters() {
      return this.filters.filter(filter => filter.enabled);
    },
    filteredRecipients() {
      return this.recipients.filter(recipient =>
        this.enabledFilters.find(filter => recipient.status === filter.name)
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
      filters: [
        { label: "Active", name: "active", enabled: true },
        { label: "Pending", name: "pending", enabled: true },
        { label: "On Hold", name: "on_hold", enabled: true },
        { label: "Archived", name: "archived", enabled: false }
      ],
      loading: true
    };
  },

  methods: {
    ...mapActions(["getAllRecipients"])
  }
};
</script>

<style lang="scss" scoped>
.button {
  margin-top: 0.3rem;
}

.filter-box {
  margin-bottom: 2.5rem;
  margin-left: 1rem;
}

.title {
  margin-left: 0.5rem !important;
  margin-bottom: 2.5rem !important;
}

.title-box {
  margin-right: 0.5rem;
}

.table {
  cursor: pointer;
}
</style>
