<template>
  <div>
    <div class="title-box">
      <b-loading :active.sync="isLoading"></b-loading>

      <h1 v-if="!isLoading" class="title is-inline-block">
        {{ details.name }}
      </h1>

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

    <RecipientMessageBox v-if="!isLoading" :status="status" @reactivate="reactivateRecipient" />

    <div v-if="status !== 'archived'" class="columns">
      npm
      <div class="column is-half">
        <div class="box">
          <h2 class="title is-4">Organisation Details</h2>

          <RecipientStatusTag :status="status" withLabel="true" size="is-medium" :isLoading="isLoading" />
          <InfoField :isLoading="isLoading" label="Full Legal Name" :value="details.name" />
          <InfoField :isLoading="isLoading" label="Base" :value="baseName" />
          <InfoField :isLoading="isLoading" label="Physical Address" :value="details.physicalAddress" />
          <InfoField :isLoading="isLoading" label="Start Date" :value="details.startedAt" />
          <InfoField :isLoading="isLoading" label="Description" :value="details.description" renderHTML="true" />
        </div>

        <div class="box">
          <h2 class="title is-4">Onboarding</h2>
          <OnboardingCheckbox
            label="Terms and conditions are signed"
            name="hasSignedTerms"
            :id="details.id"
            :value="details.hasSignedTerms"
          />
          <OnboardingCheckbox
            label="Have met Kaibosh in person"
            name="hasMetKaibosh"
            :id="details.id"
            :value="details.hasMetKaibosh"
          />
        </div>
      </div>

      <div class="column">
        <div class="box">
          <h2 class="title is-4">Primary Contact</h2>

          <InfoField :isLoading="isLoading" label="Name" :value="contact.name" />
          <InfoField :isLoading="isLoading" label="Email" :value="contact.email" />
          <InfoField :isLoading="isLoading" label="Mobile" :value="contact.phoneMobile" />
          <InfoField :isLoading="isLoading" label="Landline" :value="contact.phoneLandline" />
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
                <a v-else @click="openHoldModal" class="button is-warning">Add Hold Date</a>
              </p>
            </div>
          </div>

          <div v-if="!isLoading">
            <div v-for="session in scheduledSessions" :key="session.id" class="sessions-box">
              <ScheduledSessionCard
                :session="session"
                @edit="openEditSessionModal(session)"
                @remove="confirmSessionDeletion(session.id)"
              />
            </div>
          </div>
        </div>

        <b-modal :active.sync="isScheduledSessionModalActive" has-modal-card>
          <ScheduledSessionModal
            :baseId="details.baseId"
            :recipientId="details.id"
            :session="selectedSession"
            :sessions="scheduledSessions"
            @close="isScheduledSessionModalActive = false"
          />
        </b-modal>

        <b-modal :active.sync="isHoldModalActive" has-modal-card>
          <HoldModal @close="isHoldModalActive = false" :scheduledSessions="scheduledSessions" />
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
import { IScheduledSession, IContact } from "@/types";
import toast from "../helpers/toast";
import Bases from "@/store/modules/bases";
import { sortBy } from "lodash";
import { Route } from "vue-router";

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
  isHoldModalActive = false;
  isScheduledSessionModalActive = false;
  selectedSession: IScheduledSession | null = null;
  isLoading = true;

  async created() {
    await Promise.all([
      ActiveRecipientModule.fetchRecipient(this.id),
      RecipientSessions.fetchSessions(this.id),
      Bases.fetchBases(),
      Bases.fetchFoodCategories()
    ]);

    if (ActiveRecipientModule.details?.baseId) {
      await Bases.fetchSessionSlots({
        baseId: ActiveRecipientModule.details.baseId
      });
    }

    this.isLoading = false;
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  beforeRouteLeave(to: Route, from: Route, next: any) {
    ActiveRecipientModule.resetActiveRecipient();
    next();
  }

  get contact(): IContact {
    return ActiveRecipientModule.details.primaryContact ?? { name: "", phoneLandline: "", phoneMobile: "", email: "" };
  }

  get baseName() {
    const baseId = ActiveRecipientModule.details.baseId;
    return baseId ? Bases.baseNameById(baseId) : "";
  }

  get details() {
    return ActiveRecipientModule.details;
  }

  get status() {
    return ActiveRecipientModule.status;
  }

  get scheduledSessions() {
    return sortBy(RecipientSessions.sessions, ["sessionSlot.date"]);
  }

  updateRecipient() {
    this.$router.push(`/recipients/update/${this.id}`);
  }

  async archiveRecipient() {
    this.isLoading = true;

    if (ActiveRecipientModule.details.id) {
      await ActiveRecipientModule.archiveRecipient(ActiveRecipientModule.details.id);
      await ActiveRecipientModule.fetchRecipientStatus(this.id);
    }

    this.isLoading = false;
  }

  async reactivateRecipient() {
    this.isLoading = true;
    console.log("reactivate");

    if (ActiveRecipientModule.details.id) {
      console.log("reactivate if");
      await ActiveRecipientModule.updateRecipient({
        id: ActiveRecipientModule.details.id,
        archivedAt: null
      });
      console.log("reactivate fetch");

      await ActiveRecipientModule.fetchRecipientStatus(this.id);
    }

    console.log("reactivate done");

    this.isLoading = false;
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
