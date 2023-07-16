<script setup lang="ts">
import type { RecipientSummary } from '@/api/recipients'
import RecipientStatusTag from '../recipient/RecipientStatusTag.vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const props = defineProps<{
  recipients: RecipientSummary[]
}>()

function navigate(recipientId: string): void {
  router.push(`/recipients/${recipientId}`)
}
</script>

<template>
  <table class="table is-fullwidth is-hoverable is-striped">
    <thead>
      <th>Name</th>
      <th class="th-status">Status</th>
    </thead>
    <tbody>
      <tr
        v-for="recipient in props.recipients"
        :key="recipient.id"
        @click="navigate(recipient.id)"
      >
        <td>{{ recipient.name }}</td>
        <td><RecipientStatusTag :status="recipient.status" /></td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped lang="scss">
th {
  font-size: 0.8rem;
  letter-spacing: 0.1rem;
  text-transform: uppercase;
}

tr {
  cursor: pointer;
}

.th-status {
  width: 80px;
}
</style>
<!-- <template> -->
<!--   <b-table -->
<!--     class="table" -->
<!--     :data="recipients" -->
<!--     :loading="loading" -->
<!--     hoverable -->
<!--     striped -->
<!--     default-sort-direction="asc" -->
<!--     default-sort="name" -->
<!--     @click="viewRecipient" -->
<!--   > -->
<!--     <b-table-column v-slot="props" field="name" label="Name" sortable> -->
<!--       {{ props.row.name }} -->
<!--     </b-table-column> -->
<!--     <b-table-column v-slot="props" field="status" label="Status" centered sortable width="80"> -->
<!--       <RecipientStatusTag :status="props.row.status" /> -->
<!--     </b-table-column> -->
<!--   </b-table> -->
<!-- </template> -->

<!-- <script lang="ts"> -->
<!-- import Vue from "vue"; -->
<!-- import { Component, Prop } from "vue-property-decorator"; -->
<!-- import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue"; -->
<!-- import { IRecipientListItem } from "@/types"; -->

<!-- @Component({ components: { RecipientStatusTag } }) -->
<!-- export default class RecipientsList extends Vue { -->
<!--   @Prop({ default: false }) readonly loading!: boolean; -->
<!--   @Prop({ default: [] }) readonly recipients!: IRecipientListItem[]; -->

<!--   viewRecipient(recipient: IRecipientListItem) { -->
<!--     this.$router.push(`/recipients/${recipient.id}`); -->
<!--   } -->
<!-- } -->
<!-- </script> -->

<!-- <style lang="scss" scoped> -->
<!-- .pending { -->
<!--   height: 10rem; -->
<!-- } -->

<!-- .table { -->
<!--   cursor: pointer; -->
<!-- } -->
<!-- </style> -->
