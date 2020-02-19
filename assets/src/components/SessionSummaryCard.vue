<template>
  <div class="card">
    <header class="card-header">
      <p class="card-header-title">
        {{ session.time }}
      </p>
    </header>

    <div class="card-content">
      <div v-if="session.recipients.length === 0">No recipients.</div>
      <div v-else class="content">
        <div
          v-for="recipient in sortRecipients(session.recipients)"
          :key="recipient.id"
        >
          <AllocationRecipient :recipient="recipient" />
        </div>
      </div>
    </div>
    <footer class="card-footer">
      <router-link
        :to="`/sessions/${session.id}?date=${session.date.split(' ')[0]}`"
        class="card-footer-item"
        >View Session</router-link
      >
    </footer>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import AllocationRecipient from "@/components/AllocationRecipient.vue";
import { sortBy } from "lodash";

@Component({ components: { AllocationRecipient } })
export default class SessionSummaryCard extends Vue {
  @Prop() readonly session!: any;

  sortRecipients(list: any) {
    return sortBy(list, ["name"]);
  }
}
</script>
