<template>
  <table>
    <tbody>
      <tr v-for="hold in sortedHolds" :key="hold.id" :hold="hold">
        <td>{{ label(hold) }}</td>
        <td>
          <a @click="removeHold(hold)" class="delete is-medium"></a>
        </td>
      </tr>
      <tr></tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IHold } from "../types";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { sortBy } from "lodash";

@Component
export default class HoldTr extends Vue {
  @Prop() readonly holds!: IHold[];
  @Prop() readonly sessionId!: string;

  get sortedHolds() {
    return sortBy(this.holds, ["startsAt"]);
  }

  removeHold(hold: IHold) {
    RecipientSessions.deleteHold({
      sessionId: this.sessionId,
      ...hold
    });
  }

  label(hold: IHold) {
    if (hold.endsAt) {
      return `${hold.startsAt} - ${hold.endsAt}`;
    } else {
      return `${hold.startsAt} - (no end date)`;
    }
  }
}
</script>
