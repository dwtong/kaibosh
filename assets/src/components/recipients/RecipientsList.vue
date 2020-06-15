<template>
  <b-table
    class="table"
    :data="recipients"
    :loading="loading"
    hoverable
    striped
    default-sort-direction="asc"
    default-sort="name"
    @click="viewRecipient"
  >
    <template v-slot:empty>
      <div v-if="loading" class="pending"></div>
      <div v-else class="has-text-grey has-text-centered">
        <p><b-icon class="has-text-grey-lighter sad-icon" icon="frown" size="is-large"> </b-icon></p>
        <p>Nothing here.</p>
      </div>
    </template>

    <template v-slot="props">
      <b-table-column field="name" label="Name" sortable>
        {{ props.row.name }}
      </b-table-column>
      <b-table-column field="status" label="Status" centered sortable width="80">
        <RecipientStatusTag :status="props.row.status" />
      </b-table-column>
    </template>
  </b-table>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import { IRecipientListItem } from "@/types";

@Component({ components: { RecipientStatusTag } })
export default class RecipientsList extends Vue {
  @Prop({ default: false }) readonly loading!: boolean;
  @Prop({ default: [] }) readonly recipients!: IRecipientListItem[];

  viewRecipient(recipient: IRecipientListItem) {
    this.$router.push(`/recipients/${recipient.id}`);
  }
}
</script>

<style lang="scss" scoped>
.pending {
  height: 10rem;
}

.table {
  cursor: pointer;
}
</style>
