<template>
  <b-table
    class="table"
    :data="filteredRecipientList"
    :loading="loading"
    hoverable
    striped
    default-sort-direction="asc"
    default-sort="name"
  >
    <template slot="empty">
      <section class="section">
        <div v-if="!loading" class="has-text-grey has-text-centered">
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
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import RecipientStatusTag from "@/components/RecipientStatusTag";

export default {
  components: {
    RecipientStatusTag
  },

  computed: {
    ...mapGetters("recipients", ["filteredRecipientList"])
  },

  async created() {
    await this.getAllRecipients();
    this.loading = false;
  },

  data() {
    return {
      loading: true
    };
  },

  methods: {
    ...mapActions("recipients", ["getAllRecipients"])
  }
};
</script>

<style lang="scss" scoped>
.table {
  cursor: pointer;
}
</style>
