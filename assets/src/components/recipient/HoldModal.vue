<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" @submit="saveHold">
      <template v-slot:title>Set hold date</template>

      <div class="columns modal-card-body">
        <div class="column">
          <ValidatedDate
            ref="startDate"
            v-model="startDate"
            name="start date"
            :rules="{ required: true }"
            data-vv-as="start date"
          />
          <ValidatedDate
            v-model="endDate"
            :rules="{ required: !disableEndDate }"
            name="End date"
            :disabled="disableEndDate"
            data-vv-as="end date"
          />

          <b-checkbox type="is-info" class="end-date-checkbox" @input="toggleEndDate">No end date</b-checkbox>
          <p class="subtitle">Sessions</p>
          <b-checkbox
            type="is-info"
            :value="allSessions"
            :required="sessionHolds.length === 0"
            class="end-date-checkbox"
            @input="toggleAllSessions"
            >All sessions</b-checkbox
          >

          <div v-for="session in sessions" :key="session.id">
            <b-checkbox v-model="session.enabled" type="is-info" class="end-date-checkbox" :disabled="allSessions">
              <SessionLabel :session="session" />
            </b-checkbox>
          </div>
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IRecipientSession } from "@/types";
import RecipientSessions from "@/store/modules/recipient-sessions";
import ModalForm from "@/components/ui/ModalForm.vue";
import SessionLabel from "@/components/ui/SessionLabel.vue";
import ValidatedDate from "@/components/ui/ValidatedDate.vue";
import toast from "@/helpers/toast";

@Component({ components: { SessionLabel, ValidatedDate, ModalForm } })
export default class HoldModal extends Vue {
  @Prop() recipientSessions!: IRecipientSession[];
  @Prop() recipientId!: string;
  startDate: Date = new Date();
  endDate: Date | null = null;
  disableEndDate = false;
  allSessions = false;
  sessions: IRecipientSession[] = [];
  isOpen = false;

  openModal() {
    this.sessions = this.recipientSessions.map(s => {
      return { enabled: false, ...s };
    });
    this.isOpen = true;
  }

  async saveHold() {
    if (this.sessionHolds.length > 0) {
      await RecipientSessions.createHolds({ recipientId: this.recipientId, holds: this.sessionHolds });
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
          recipientSessionId: s.id,
          startsAt: this.startDate.toISOString(),
          endsAt: endDate ? endDate.toISOString() : ""
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
}
</script>

<style lang="scss" scoped>
.end-date-checkbox {
  margin-top: 0.5rem;
  margin-left: 0.1rem;
}

.modal-card-body {
  height: 550px;
}

.subtitle {
  margin-top: 2rem;
}
</style>
