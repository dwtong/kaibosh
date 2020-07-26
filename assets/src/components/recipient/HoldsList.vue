<template>
  <table>
    <tbody>
      <tr v-for="hold in sortedHolds" :key="hold.id" :hold="hold">
        <td v-if="hold.endsAt">{{ hold.startsAt | formatDate }} - {{ hold.endsAt | formatDate }}</td>
        <td v-else>{{ hold.startsAt | formatDate }} - (no end date)</td>
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

  get sortedHolds() {
    return sortBy(this.holds, ["startsAt"]);
  }

  removeHold(holdId: string) {
    RecipientSessions.deleteHold({ recipientId: this.recipientId, holdId });
  }
}
</script>
