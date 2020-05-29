<template>
  <form @submit.prevent="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Set hold date</p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <DateField name="start date" v-model="startDate" required="true" ref="startDate" data-vv-as="start date" />
            <DateField
              :required="!disableEndDate"
              name="End date"
              v-model="endDate"
              :disabled="disableEndDate"
              v-validate="'date_format:dd/MM/yyyy|after:startDate'"
              data-vv-as="end date"
            />

            <b-checkbox type="is-info" @input="toggleEndDate" class="end-date-checkbox">No end date</b-checkbox>
          </div>
        </div>
        <p class="subtitle">Sessions</p>
        <b-checkbox
          type="is-info"
          :value="allSessions"
          @input="toggleAllSessions"
          :required="sessionHolds.length === 0"
          class="end-date-checkbox"
          >All sessions</b-checkbox
        >

        <div v-for="session in sessions" :key="session.id">
          <b-checkbox type="is-info" class="end-date-checkbox" v-model="session.enabled" :disabled="allSessions">
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
import { IScheduledSession } from "../types";
import RecipientSessions from "../store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/AllocationQuantitiesInput.vue";
import DateField from "@/components/form/DateField.vue";
import toast from "@/helpers/toast";

@Component({
  components: { AllocationQuantitiesInput, DateField },
  // eslint-disable-next-line @typescript-eslint/camelcase
  $_veeValidate: { validator: "new" }
})
export default class HoldModal extends Vue {
  @Prop() scheduledSessions!: IScheduledSession[];
  startDate: Date = new Date();
  endDate: Date | null = null;
  disableEndDate = false;
  allSessions = false;
  sessions: IScheduledSession[] = [];

  created() {
    this.sessions = this.scheduledSessions.map(s => {
      return { enabled: false, ...s };
    });
  }

  async saveHold() {
    const formIsValid = await this.$validator.validateAll();

    if (formIsValid && this.sessionHolds.length > 0) {
      await RecipientSessions.createHolds(this.sessionHolds);
      this.$emit("close");
      toast.success("Session hold created.");
    }
  }

  get sessionHolds() {
    const endDate = this.disableEndDate ? null : this.endDate;

    return this.sessions
      .filter(s => s.enabled)
      .map(s => {
        return {
          sessionId: s.id!,
          startsAt: this.startDate.toString(),
          endsAt: endDate ? endDate.toString() : ""
        };
      })
      .filter(h => h !== null);
  }

  toggleEndDate(isDisabled: boolean) {
    this.disableEndDate = isDisabled;
  }

  toggleAllSessions() {
    this.allSessions = !this.allSessions;
    this.sessions.forEach(s => (s.enabled = this.allSessions));
  }

  sessionSlotLabel(session: IScheduledSession) {
    if (session.sessionSlot) {
      return `${session.sessionSlot.day} ${session.sessionSlot.time}`;
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
