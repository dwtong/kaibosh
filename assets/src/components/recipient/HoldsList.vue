<template>
  <table>
    <tbody>
      <tr v-for="hold in sortedHolds" :key="hold.id" :hold="hold">
        <td v-if="hold.endsAt">{{ formatDate(hold.startsAt) }} - {{ formatDate(hold.endsAt) }}</td>
        <td v-else>{{ formatDate(hold.startsAt) }} - (no end date)</td>
        <td>
          <a class="delete is-medium" @click="removeHold(hold.id)"></a>
        </td>
      </tr>
      <tr></tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { formatDate } from "@/helpers/date";
import { sortBy } from "lodash";

@Component({ filters: { formatDate } })
export default class HoldTr extends Vue {
  @Prop() readonly holds!: any[];
  @Prop() readonly recipientId!: string;

  formatDate(date: any) {
    return formatDate(date);
  }

  get sortedHolds() {
    return sortBy(this.holds, ["startsAt"]);
  }

  removeHold(holdId: string) {
    RecipientSessions.deleteHold({ recipientId: this.recipientId, holdId });
  }
}
</script>
