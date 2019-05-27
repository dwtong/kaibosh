<template>
  <div>
    <div class="title-box">
      <h1 class="title is-inline-block">{{ details.name }}</h1>

      <div class="field has-addons buttons is-pulled-right">
        <p class="control">
          <a class="button ">
            Edit Recipient
          </a>
        </p>
        <p class="control">
          <a @click="openSessionModal" class="button">
            Add Sorting Session
          </a>
        </p>
      </div>
    </div>

    <div class="columns">
      <div class="column is-two-fifths">
        <div class="box">
          <h2 class="title is-4">Organisation Details</h2>

          <InfoField label="Full Legal Name" :value="details.name" />
          <InfoField label="Base" :value="details.base.name" />
          <InfoField label="Status" :value="details.status" />
          <InfoField
            label="Physical Address"
            :value="details.physical_address"
          />
        </div>

        <div class="box">
          <h2 class="title is-4">Primary Contact</h2>

          <InfoField label="Name" :value="details.primary_contact.name" />
          <InfoField label="Email" :value="details.primary_contact.email" />
          <InfoField label="Mobile" :value="details.primary_contact.mobile" />
          <InfoField
            label="Landline"
            :value="details.primary_contact.landline"
          />
        </div>
        <div class="box">
          <h2 class="title is-4">Onboarding</h2>
          <div class="field">
            <b-checkbox type="is-info"
              >Terms and conditions are signed</b-checkbox
            >
          </div>
          <div class="field">
            <b-checkbox type="is-info">Have met Kaibosh in person</b-checkbox>
          </div>
        </div>

        <div class="box">
          <h2 class="title is-4">Files</h2>
          <b-field class="file">
            <b-upload>
              <a class="button is-primary">
                <b-icon icon="upload"></b-icon>
                <span>Click to upload</span>
              </a>
            </b-upload>
          </b-field>
        </div>
      </div>

      <div class="column">
        <div class="box">
          <h2 class="title is-4 is-inline-block">Sorting Sessions</h2>

          <div v-for="session in scheduledSessions" :key="session.id">
            <ScheduledSessionCard
              :session="session"
              @edit="openSessionModal(session.id)"
              @remove="confirmSessionDeletion(session.id)"
            />
          </div>
        </div>

        <b-modal :active.sync="isScheduledSessionModalActive" has-modal-card>
          <ScheduledSessionModal
            :baseId="details.base.id"
            :recipientId="details.id"
            :sessionId="selectedSessionId"
            @close="isScheduledSessionModalActive = false"
          />
        </b-modal>
      </div>
    </div>
  </div>
</template>

<script>
import ScheduledSessionCard from "@/components/ScheduledSessionCard";
import ScheduledSessionModal from "@/components/ScheduledSessionModal";
import InfoField from "@/components/form/InfoField";
import { mapActions, mapState } from "vuex";
import toast from "@/helpers/toast";

export default {
  components: {
    ScheduledSessionCard,
    ScheduledSessionModal,
    InfoField
  },

  computed: {
    ...mapState("recipients", ["details", "scheduledSessions"])
  },

  async created() {
    await this.getRecipient(this.id);
    await this.getScheduledSessions(this.details.id);
  },

  data() {
    return {
      isScheduledSessionModalActive: false,
      selectedSessionId: null
    };
  },

  methods: {
    ...mapActions("recipients", [
      "getRecipient",
      "getScheduledSessions",
      "deleteScheduledSession"
    ]),

    confirmSessionDeletion(sessionId) {
      this.$dialog.confirm({
        message: "Are you sure you wish to remove this session?",
        type: "is-danger",
        onConfirm: async () => {
          this.deleteScheduledSession(sessionId);
          await this.getScheduledSessions(this.details.id);
          toast.success("Deleted session.");
        }
      });
    },
    openSessionModal(id) {
      if (Number.isInteger(id)) {
        this.selectedSessionId = id;
      } else {
        this.selectedSessionId = null;
      }

      this.isScheduledSessionModalActive = true;
    }
  },

  props: ["id"]
};
</script>

<style lang="scss" scoped>
.loading {
  height: 100%;
  width: 100%;
}
</style>
