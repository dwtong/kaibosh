<template>
  <table class="table">
    <thead>
      <tr>
        <th>Name</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="recipient in recipients" :key="recipient.id">
        <td>{{ recipient.name }}</td>
        <td><RecipientStatusTag :status="recipient.status" /></td>
      </tr>
    </tbody>
  </table>
  <!-- <b-table -->
  <!--   class="table" -->
  <!--   :data="recipients" -->
  <!--   :loading="loading" -->
  <!--   hoverable -->
  <!--   striped -->
  <!--   default-sort-direction="asc" -->
  <!--   default-sort="name" -->
  <!--   @click="viewRecipient" -->
  <!-- > -->
  <!--   <b-table-column v-slot="props" field="name" label="Name" sortable> -->
  <!--     {{ props.row.name }} -->
  <!--   </b-table-column> -->
  <!--   <b-table-column v-slot="props" field="status" label="Status" centered sortable width="80"> -->
  <!--     <RecipientStatusTag :status="props.row.status" /> -->
  <!--   </b-table-column> -->
  <!-- </b-table> -->
</template>

<script lang="ts">
import { defineComponent } from "vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import { IRecipientListItem } from "@/types";

export default defineComponent({
  components: {
    RecipientStatusTag
  },
  props: {
    loading: {
      type: Boolean,
      default: false
    },
    recipients: {
      type: Array,
      default: () => []
    }
  },
  methods: {
    viewRecipient(recipient: IRecipientListItem) {
      this.$router.push(`/recipients/${recipient.id}`);
    }
  }
});
</script>

<style lang="scss" scoped>
.pending {
  height: 10rem;
}

.table {
  cursor: pointer;
}
</style>
