<template>
  <b-table
    class="table"
    :data="filteredRecipients"
    :loading="filteredRecipients.length == 0 && loading"
    hoverable
    striped
    default-sort-direction="asc"
    default-sort="name"
    @click="viewRecipient"
  >
    <template slot="empty">
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
      <div v-else class="pending"></div>
    </template>

    <template slot-scope="props">
      <b-table-column field="name" label="Name" sortable>{{
        props.row.name
      }}</b-table-column>

      <b-table-column
        field="status"
        label="Status"
        centered
        sortable
        width="80"
      >
        <RecipientStatusTag :status="props.row.status" />
      </b-table-column>
    </template>
  </b-table>
</template>

<script>
import { mapActions, mapGetters, mapState } from "vuex";
import RecipientStatusTag from "@/components/RecipientStatusTag";

export default {
  components: {
    RecipientStatusTag
  },

  computed: {
    ...mapGetters("recipients", ["filteredRecipients"]),
    ...mapState("recipients", ["loading", "list"])
  },

  async created() {
    await this.getRecipients();
  },

  methods: {
    ...mapActions("recipients", ["getRecipients"]),
    viewRecipient({ id }) {
      this.$router.push(`/recipients/${id}`);
    }
  }
};
</script>

<style lang="scss" scoped>
.pending {
  height: 10rem;
}

.table {
  cursor: pointer;
}
</style>
