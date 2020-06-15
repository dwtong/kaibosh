<template>
  <table>
    <tbody>
      <tr v-for="hold in sortedHolds" :key="hold.id" :hold="hold">
        <td>{{ label(hold) }}</td>
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
import { sortBy } from "lodash";

@Component
export default class HoldTr extends Vue {
  @Prop() readonly holds!: any[];
  @Prop() readonly sessionId!: string;

  get sortedHolds() {
    return sortBy(this.holds, ["startsAt"]);
  }

  removeHold(holdId: string) {
    RecipientSessions.deleteHold(this.sessionId, holdId);
  }

  label(hold: any) {
    if (hold.endsAt) {
      return `${hold.startsAt} - ${hold.endsAt}`;
    } else {
      return `${hold.startsAt} - (no end date)`;
    }
  }
}
</script>
