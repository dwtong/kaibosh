<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">Food Recipients</h1>
      <button class="button is-primary is-pulled-right">Create Recipient</button>
    </div>

    <div class="box">
      <b-table
        class="table"
        :data="recipients"
        hoverable
        default-sort-direction="asc"
        default-sort="name"
      >
        <template slot-scope="props">
          <b-table-column field="name" label="Name" sortable>
            {{
            props.row.name
            }}
          </b-table-column>

          <b-table-column field="status" label="Status" centered sortable>
            <RecipientStatusTag :status="props.row.status"/>
          </b-table-column>
        </template>
      </b-table>
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
    ...mapGetters(["recipients"])
  },
  async created() {
    await this.getAllRecipients();
    this.loading = false;
  },

  data() {
    return {
      columns: [
        { field: "name", label: "Name" },
        { field: "status", label: "Status" }
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
.title {
  margin-left: 0.5rem !important;
  margin-bottom: 2.5rem !important;
}

.title-box {
  margin-right: 0.5rem;
}

.table {
  cursor: pointer;

  td {
    padding-top: 0.8rem;
    padding-bottom: 0.8rem;
  }

  thead {
    background-color: red !important;
  }
}
</style>
