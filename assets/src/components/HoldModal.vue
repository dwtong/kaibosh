<template>
  <form @submit.prevent="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Set hold date</p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <DateField name="start date" v-model="startDate" required="true" />
            <DateField
              name="End date"
              v-model="endDate"
              :disabled="disableEndDate"
            />

            <b-checkbox
              type="is-info"
              @input="toggleEndDate"
              class="end-date-checkbox"
              >No end date</b-checkbox
            >
          </div>
        </div>
        <p class="subtitle">Sessions</p>
        <b-checkbox
          type="is-info"
          :value="allSessions"
          @input="toggleAllSessions"
          class="end-date-checkbox"
          >All sessions</b-checkbox
        >

        <div v-for="session in sessions" :key="session.id">
          <b-checkbox
            type="is-info"
            class="end-date-checkbox"
            v-model="session.enabled"
            :disabled="allSessions"
          >
            {{ sessionSlotLabel(session) }}
          </b-checkbox>
        </div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button class="button is-light" type="button" @click="$emit('close')">
            Cancel
          </button>
          <button type="submit" class="button is-info" @click="saveHold">
            Save
          </button>
        </div>
      </footer>
    </div>
  </form>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession, IAllocation, ISessionSlot } from "../types";
import { ActiveRecipientModule } from "../store/modules/active-recipient";
import { BasesModule } from "../store/modules/bases";
import AllocationQuantitiesInput from "@/components/AllocationQuantitiesInput.vue";
import DateField from "@/components/form/DateField.vue";
import toast from "@/helpers/toast";

@Component({ components: { AllocationQuantitiesInput, DateField } })
export default class HoldModal extends Vue {
  @Prop() scheduledSessions!: IScheduledSession[];
  startDate: Date = new Date();
  endDate: Date = new Date();
  disableEndDate: boolean = false;
  allSessions: boolean = false;
  sessions: IScheduledSession[] = [];

  created() {
    this.sessions = this.scheduledSessions.map(s => {
      return { enabled: false, ...s };
    });
  }

  async saveHold() {
    const endDate = this.disableEndDate ? null : this.endDate;
    const sessionHolds = this.sessions
      .filter(s => s.enabled)
      .map(s => {
        return {
          scheduled_session_id: s.id!,
          starts_at: this.startDate.toString(),
          ends_at: endDate ? endDate.toString() : ""
        };
      })
      .filter(h => h !== null);
    await ActiveRecipientModule.createHolds(sessionHolds);

    this.$emit("close");
    toast.success("Session hold created.");
  }

  toggleEndDate(isDisabled: boolean) {
    this.disableEndDate = isDisabled;
  }

  toggleAllSessions() {
    this.allSessions = !this.allSessions;
    this.sessions.forEach(s => (s.enabled = this.allSessions));
  }

  sessionSlotLabel(session: IScheduledSession) {
    if (session.session_slot) {
      return `${session.session_slot.day} ${session.session_slot.time}`;
    } else {
      return "";
    }
  }
}
</script>

<style lang="scss" scoped>
.end-date-checkbox {
  margin-top: 0.5rem;
  margin-left: 0.1rem;
}

.modal-card {
  width: 400px;
}

.modal-card-body {
  height: 550px;
}

.subtitle {
  margin-top: 2rem;
}
</style>
