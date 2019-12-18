<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">{{ details.name }}</h1>

      <div v-if="status !== 'archived'" class="field buttons is-pulled-right">
        <p class="control">
          <a @click="updateRecipient" class="button is-info">
            Edit Recipient
          </a>
        </p>
        <p class="control">
          <a @click="archiveRecipient" class="button is-danger">
            Archive Recipient
          </a>
        </p>
      </div>
    </div>

    <RecipientMessageBox />

    <div v-if="status !== 'archived'" class="columns">
      <div class="column is-half">
        <div class="box">
          <h2 class="title is-4">Organisation Details</h2>

          <RecipientStatusTag
            :status="status"
            withLabel="true"
            size="is-medium"
          />
          <InfoField label="Full Legal Name" :value="details.name" />
          <InfoField label="Base" :value="baseName" />
          <InfoField
            label="Physical Address"
            :value="details.physical_address"
          />
          <InfoField label="Start Date" :value="details.started_at" />
          <InfoField label="Description" :value="details.description" />
        </div>

        <div class="box">
          <h2 class="title is-4">Onboarding</h2>
          <OnboardingCheckbox
            label="Terms and conditions are signed"
            name="has_signed_terms"
            :id="details.id"
            :value="details.has_signed_terms"
          />
          <OnboardingCheckbox
            label="Have met Kaibosh in person"
            name="has_met_kaibosh"
            :id="details.id"
            :value="details.has_met_kaibosh"
          />
        </div>
      </div>

      <div class="column">
        <div class="box">
          <h2 class="title is-4">Primary Contact</h2>

          <InfoField label="Name" :value="contact.name" />
          <InfoField label="Email" :value="contact.email" />
          <InfoField label="Mobile" :value="contact.phone_mobile" />
          <InfoField label="Landline" :value="contact.phone_landline" />
        </div>

        <div class="box">
          <div class="">
            <h1 class="title is-4 is-inline-block">Sorting Sessions</h1>

            <div v-if="status !== 'archived'" class="field buttons">
              <p class="control">
                <a @click="openCreateSessionModal" class="button is-info">
                  Add Sorting Session
                </a>
              </p>
              <p class="control">
                <b-tooltip
                  v-if="scheduledSessions.length === 0"
                  label="Hold date cannot be added without session"
                  position="is-bottom"
                  type="is-warning"
                >
                  <a disabled="true" class="button is-warning">
                    Add Hold Date
                  </a>
                </b-tooltip>
                <a v-else @click="openHoldModal" class="button is-warning"
                  >Add Hold Date</a
                >
              </p>
            </div>
          </div>

          <div
            v-for="session in scheduledSessions"
            :key="session.id"
            class="sessions-box"
          >
            <ScheduledSessionCard
              :session="session"
              @edit="openEditSessionModal(session)"
              @remove="confirmSessionDeletion(session.id)"
            />
          </div>
        </div>

        <b-modal :active.sync="isScheduledSessionModalActive" has-modal-card>
          <ScheduledSessionModal
            :baseId="details.base_id"
            :recipientId="details.id"
            :session="selectedSession"
            :sessions="scheduledSessions"
            @close="isScheduledSessionModalActive = false"
          />
        </b-modal>

        <b-modal :active.sync="isHoldModalActive" has-modal-card>
          <HoldModal
            @close="isHoldModalActive = false"
            :scheduledSessions="scheduledSessions"
          />
        </b-modal>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import OnboardingCheckbox from "@/components/form/OnboardingCheckbox.vue";
import RecipientMessageBox from "@/components/form/RecipientMessageBox.vue";
import RecipientStatusTag from "@/components/form/RecipientStatusTag.vue";
import ScheduledSessionCard from "@/components/ScheduledSessionCard.vue";
import ScheduledSessionModal from "@/components/ScheduledSessionModal.vue";
import { ActiveRecipientModule } from "@/store/modules/active-recipient";
import RecipientSessions from "@/store/modules/recipient-sessions";
import HoldModal from "@/components/HoldModal.vue";
import InfoField from "@/components/form/InfoField.vue";
import { IRecipient, IScheduledSession } from "@/types";
import toast from "../helpers/toast";
import { BasesModule } from "../store/modules/bases";

@Component({
  components: {
    HoldModal,
    OnboardingCheckbox,
    RecipientMessageBox,
    RecipientStatusTag,
    ScheduledSessionCard,
    ScheduledSessionModal,
    InfoField
  }
})
export default class ShowRecipient extends Vue {
  @Prop(String) readonly id!: string;
  isHoldModalActive: boolean = false;
  isScheduledSessionModalActive: boolean = false;
  selectedSession: IScheduledSession | null = null;

  async created() {
    await Promise.all([
      ActiveRecipientModule.fetchRecipient(this.id),
      RecipientSessions.fetchSessions(this.id),
      BasesModule.fetchBases(),
      BasesModule.fetchFoodCategories()
    ]);

    if (ActiveRecipientModule.details) {
      await BasesModule.fetchSessionSlots(
        ActiveRecipientModule.details.base_id!
      );
    }
  }

  beforeRouteLeave(to: any, from: any, next: any) {
    ActiveRecipientModule.resetActiveRecipient();
    next();
  }

  get contact() {
    return ActiveRecipientModule.details.primary_contact;
  }

  get baseName() {
    const baseId = ActiveRecipientModule.details.base_id;
    return BasesModule.baseNameById(baseId!);
  }

  get details() {
    return ActiveRecipientModule.details;
  }

  get status() {
    return ActiveRecipientModule.status;
  }

  get scheduledSessions() {
    return RecipientSessions.sessions;
  }

  updateRecipient() {
    this.$router.push(`/recipients/update/${this.id}`);
  }

  archiveRecipient() {
    if (ActiveRecipientModule.details.id) {
      ActiveRecipientModule.archiveRecipient(ActiveRecipientModule.details.id);
    }
  }

  openHoldModal() {
    this.isHoldModalActive = true;
  }

  openCreateSessionModal() {
    this.selectedSession = null;
    this.isScheduledSessionModalActive = true;
  }

  openEditSessionModal(session: IScheduledSession) {
    this.selectedSession = session;
    this.isScheduledSessionModalActive = true;
  }

  confirmSessionDeletion(sessionId: string) {
    this.$dialog.confirm({
      message: "Are you sure you wish to remove this session?",
      type: "is-danger",
      onConfirm: async () => {
        await RecipientSessions.deleteSession(sessionId);
        toast.success("Deleted session.");
      }
    });
  }
}
</script>

<style lang="scss" scoped>
.buttons {
  .button {
    margin-right: 7px;
  }
}

.loading {
  height: 100%;
  width: 100%;
}

.sessions-box {
  margin-top: 25px;
}

.title-box {
  height: 60px;
}
</style>
