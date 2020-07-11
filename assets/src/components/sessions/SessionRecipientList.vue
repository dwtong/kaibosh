<template>
  <div class="card">
    <header class="card-header">
      <p class="card-header-title">
        {{ session.time }}
      </p>
    </header>

    <div class="card-content">
      <div v-if="session.recipients.length === 0" class="is-hidden-print">
        No recipients.
      </div>
      <div v-else class="content">
        <div v-for="recipient in sortRecipients(session.recipients)" :key="recipient.id">
          <SessionRecipient :recipient="recipient" />
        </div>
      </div>
    </div>
    <footer class="card-footer is-hidden-print">
      <router-link :to="`/sessions/${session.id}?date=${session.date.split(' ')[0]}`" class="card-footer-item"
        >View Session</router-link
      >
    </footer>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import SessionRecipient from "@/components/sessions/SessionRecipient.vue";
import { sortBy } from "lodash";

@Component({ components: { SessionRecipient } })
export default class SessionRecipientList extends Vue {
  @Prop() readonly session!: any;

  sortRecipients(list: any) {
    return sortBy(list, ["name"]);
  }
}
</script>

<style lang="scss" scoped>
.card-content {
  @media print {
    padding: 5px;
    font-size: 12px;
  }
}

.card-header-title {
  @media print {
    padding: 5px;
    font-size: 12px;
  }
}
</style>
