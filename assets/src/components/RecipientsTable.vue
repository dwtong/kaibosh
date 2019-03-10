<template>
  <b-table
    class="table"
    :data="data"
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
</template>

<script>
import RecipientStatusTag from "@/components/RecipientStatusTag";

export default {
  components: {
    RecipientStatusTag
  },
  props: ["data"]
};
</script>

<style lang="scss" scoped>
.table {
  cursor: pointer;
}
</style>
