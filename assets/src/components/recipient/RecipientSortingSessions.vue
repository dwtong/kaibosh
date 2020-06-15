<template>
  <div class="box">
    <div>
      <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>

      <div v-if="status !== 'archived'" class="field buttons">
        <p class="control">
          <a class="button is-info" :disabled="loading" @click="openCreateSessionModal">
            Add Sorting Session
          </a>
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

    <div>
      <div v-for="session in scheduledSessions" :key="session.id" class="sessions-box">
        <ScheduledSessionCard
          :session="session"
          @edit="openEditSessionModal(session)"
          @remove="confirmSessionDeletion(session.id)"
        />
      </div>
    </div>

    <b-modal :active.sync="isScheduledSessionModalActive" has-modal-card>
      <ScheduledSessionModal
        :base-id="baseId"
        :recipient-id="id"
        :session="selectedSession"
        :sessions="scheduledSessions"
        @close="isScheduledSessionModalActive = false"
      />
    </b-modal>

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
import ScheduledSessionCard from "@/components/recipient/ScheduledSessionCard.vue";
import ScheduledSessionModal from "@/components/recipient/ScheduledSessionModal.vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import { IScheduledSession } from "@/types";
import { sortBy } from "lodash";
import toast from "@/helpers/toast";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import SessionSlots from "@/store/modules/session-slots";

@Component({ components: { InfoField, RecipientStatusTag, ScheduledSessionCard, ScheduledSessionModal } })
export default class RecipientSortingSessions extends Vue {
  isHoldModalActive = false;
  isScheduledSessionModalActive = false;
  selectedSession: IScheduledSession | null = null;

  id = ActiveRecipientModule.details?.id ?? null;
  baseId = ActiveRecipientModule.details?.baseId;
  status = ActiveRecipientModule.status;
  loading = true;

  async created() {
    if (this.id && this.baseId) {
      await Promise.all([RecipientSessions.fetchSessions(this.id), SessionSlots.fetchList({ baseId: this.baseId })]);
    }
    this.loading = false;
  }

  openHoldModal() {
    this.isHoldModalActive = true;
  }

  get scheduledSessions() {
    return sortBy(RecipientSessions.sessions, ["sessionSlot.date"]);
  }

  openCreateSessionModal() {
    this.selectedSession = null;
    this.isScheduledSessionModalActive = true;
  }

  openEditSessionModal(session: IScheduledSession) {
    this.selectedSession = session;
    this.isScheduledSessionModalActive = true;
  }

  confirmSessionDeletion(sessionId?: string) {
    if (sessionId) {
      this.$buefy.dialog.confirm({
        message: "Are you sure you wish to remove this session?",
        type: "is-danger",
        onConfirm: async () => {
          await RecipientSessions.deleteSession(sessionId);
          toast.success("Deleted session.");
        }
      });
    }
  }
}
</script>

<style lang="scss" scoped>
.sessions-box {
  margin-top: 25px;
}
</style>
