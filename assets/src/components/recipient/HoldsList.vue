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
import { defineComponent } from "vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { formatDate } from "@/helpers/date";
import { sortBy } from "lodash";

export default defineComponent({
  props: {
    holds: {
      type: Array,
      required: true
    },
    recipientId: {
      type: String,
      required: true
    }
  },
  computed: {
    sortedHolds(): any {
      return sortBy(this.holds, ["startsAt"]);
    }
  },
  methods: {
    formatDate(date: any) {
      return formatDate(date);
    },

    removeHold(holdId: string) {
      RecipientSessions.deleteHold({ recipientId: this.recipientId, holdId });
    }
  }
});
</script>
