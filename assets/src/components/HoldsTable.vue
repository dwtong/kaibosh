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
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import { sortBy } from "lodash";

@Component
export default class HoldTr extends Vue {
  @Prop() readonly holds!: IHold[];
  @Prop() readonly sessionId!: string;

  get sortedHolds() {
    return sortBy(this.holds, ["starts_at"]);
  }

  removeHold(hold: IHold) {
    ActiveRecipientModule.deleteHold({
      scheduled_session_id: this.sessionId,
      ...hold
    });
  }

  label(hold: IHold) {
    if (hold.ends_at) {
      return `${hold.starts_at} - ${hold.ends_at}`;
    } else {
      return `${hold.starts_at} - (no end date)`;
    }
  }
}
</script>
