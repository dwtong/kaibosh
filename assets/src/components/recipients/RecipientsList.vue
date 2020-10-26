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
    <b-table-column field="name" label="Name" v-slot="props" sortable>
      {{ props.row.name }}
    </b-table-column>
    <b-table-column field="status" label="Status" v-slot="props" centered sortable width="80">
      <RecipientStatusTag :status="props.row.status" />
    </b-table-column>
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
