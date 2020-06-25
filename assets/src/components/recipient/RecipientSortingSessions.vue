<template>
  <div class="box">
    <div>
      <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>

      <div v-if="status !== 'archived'" class="field buttons">
        <p class="control">
          <SessionCreateModal v-slot="{ open }" :base-id="baseId" :recipient-id="id" :sessions="scheduledSessions">
            <a class="button is-info" :disabled="loading" :class="{ 'is-loading': loading }" @click="open">
              Add Sorting Session
            </a>
          </SessionCreateModal>
        </p>

        <p class="control">
          <b-tooltip
            v-if="loading || scheduledSessions.length === 0"
            label="Hold date cannot be added without session"
            position="is-bottom"
            type="is-warning"
          >
            <a disabled="true" class="button is-warning">
              Add Hold Date
            </a>
          </b-tooltip>
          <a v-else class="button is-warning" @click="openHoldModal">Add Hold Date</a>
        </p>
      </div>
    </div>

    <div v-if="!loading">
      <div v-for="session in scheduledSessions" :key="session.id" class="sessions-box">
        <!-- <SessionCard
          :session="session"
          @edit="openEditSessionModal(session, open)"
          @remove="confirmSessionDeletion(session.id)"
        /> -->
      </div>
    </div>

    <b-modal :active.sync="isHoldModalActive" has-modal-card>
      <HoldModal :scheduled-sessions="scheduledSessions" @close="isHoldModalActive = false" />
    </b-modal>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component } from "vue-property-decorator";
import InfoField from "@/components/ui/InfoField.vue";
import RecipientStatusTag from "@/components/recipient/RecipientStatusTag.vue";
import SessionCard from "@/components/recipient/SessionCard.vue";
import SessionCreateModal from "@/components/recipient/SessionCreateModal.vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { IScheduledSession } from "@/types";
import { sortBy } from "lodash";
import ActiveRecipient from "@/store/modules/active-recipient";

@Component({ components: { InfoField, RecipientStatusTag, SessionCard, SessionCreateModal } })
export default class RecipientSortingSessions extends Vue {
  isHoldModalActive = false;
  selectedSession: IScheduledSession | null = null;

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

  openHoldModal() {
    this.isHoldModalActive = true;
  }

  get scheduledSessions() {
    return sortBy(RecipientSessions.sessions, ["sessionSlot.date"]);
  }
}
</script>

<style lang="scss" scoped>
.sessions-box {
  margin-top: 25px;
}
</style>
