<template>
  <div class="box">
    <div>
      <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>

      <div v-if="status !== 'archived'" class="field buttons">
        <p class="control">
          <SessionModal v-slot="{ open }" :base-id="baseId" :recipient-id="id" :sessions="recipientSessions">
            <a class="button is-info" :disabled="loading" :class="{ 'is-loading': loading }" @click="open">
              Add Sorting Session
            </a>
          </SessionModal>
        </p>

        <p class="control">
          <b-tooltip
            v-if="loading || recipientSessions.length === 0"
            label="Hold date cannot be added without session"
            position="is-bottom"
            type="is-warning"
          >
            <a disabled="true" class="button is-warning"> Add Hold Date </a>
          </b-tooltip>
          <HoldModal v-else v-slot="{ open }" :recipient-sessions="recipientSessions" :recipient-id="id">
            <a class="button is-warning" @click="open">Add Hold Date</a>
          </HoldModal>
        </p>
      </div>
    </div>

    <div v-if="!loading">
      <div v-for="session in recipientSessions" :key="session.id" class="sessions-box">
        <SessionCard
          :recipient-session="session"
          :recipient-sessions="recipientSessions"
          :base-id="baseId"
          :recipient-id="id"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import InfoField from "@/components/ui/InfoField.vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import HoldModal from "@/components/recipient/HoldModal.vue";
import SessionCard from "@/components/recipient/SessionCard.vue";
import SessionModal from "@/components/recipient/SessionModal.vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { IRecipientSession } from "@/types";
import { sortBy } from "lodash";
import ActiveRecipient from "@/store/modules/active-recipient";
import { dayIndexFromString } from "@/helpers/date";

@Component({ components: { InfoField, HoldModal, RecipientStatusTag, SessionCard, SessionModal } })
export default class RecipientSortingSessions extends Vue {
  selectedSession: IRecipientSession | null = null;
  id = ActiveRecipient.details?.id ?? null;
  baseId = ActiveRecipient.details?.baseId;
  status = ActiveRecipient.status;
  loading = true;

  async created() {
    if (this.id && this.baseId) {
      await RecipientSessions.fetchSessions(this.id);
    }
    this.loading = false;
  }

  get recipientSessions() {
    return sortBy(RecipientSessions.sessions, (s: any) => `${dayIndexFromString(s.day)}-${s.time}`);
  }
}
</script>

<style lang="scss" scoped>
.sessions-box {
  margin-top: 25px;
}
</style>
