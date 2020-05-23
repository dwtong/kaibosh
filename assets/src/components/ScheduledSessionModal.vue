<template>
  <form @submit.prevent="">
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">{{ this.session ? "Edit " : "Add" }} Sorting Session</p>
      </header>

      <section class="modal-card-body">
        <div class="columns">
          <div class="column">
            <p class="subtitle">Select session time and day</p>
            <SessionSlotSelect v-model="selectedSessionSlotId" />

            <p v-if="!sessionIsValid" class="error-msg">
              Selected session already exists.
            </p>
          </div>
        </div>

        <div v-if="selectedSessionSlotId && sessionIsValid" class="columns">
          <div class="column">
            <p class="subtitle">Choose food categories</p>
            <AllocationQuantitiesInput v-model="allocations" />
          </div>
        </div>
      </section>

      <footer class="modal-card-foot">
        <div class="buttons">
          <button class="button is-light" type="button" @click="$emit('close')">
            Cancel
          </button>
          <button
            :disabled="!selectedSessionSlotId || !sessionIsValid"
            type="submit"
            class="button is-info"
            @click="saveSession"
          >
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
import { IScheduledSession, IAllocation } from "../types";
import RecipientSessions from "../store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";
import SessionSlotSelect from "@/components/form/SessionSlotSelect.vue";

@Component({ components: { SessionSlotSelect, AllocationQuantitiesInput } })
export default class ScheduledSessionModal extends Vue {
  @Prop() readonly recipientId!: string;
  @Prop() readonly baseId: string | undefined;
  @Prop() readonly session?: IScheduledSession;
  @Prop() readonly sessions?: IScheduledSession[];
  allocations: IAllocation[] = [];
  selectedSessionSlotId = "";

  created() {
    if (this.session) {
      this.allocations = this.session.allocations ? [...this.session.allocations] : [];
      this.selectedSessionSlotId = this.session.sessionSlot?.id ?? "";
    }
  }

  get sessionIsValid() {
    const isExistingSession = !!this.session;
    const newSessionExists = this.sessions?.find(
      (s: IScheduledSession) => s.sessionSlot && s.sessionSlot.id === this.selectedSessionSlotId
    );
    return isExistingSession || !newSessionExists;
  }

  async saveSession() {
    const params = {
      recipientId: this.recipientId,
      sessionSlotId: this.selectedSessionSlotId,
      allocationsAttributes: this.allocations
    };

    if (this.session) {
      await RecipientSessions.updateSession({
        ...params,
        ...this.session
      });
    } else {
      await RecipientSessions.createSession(params);
    }

    this.$emit("close");
    toast.success("Scheduled session created.");
  }
}
</script>

<style lang="scss" scoped>
.modal-card {
  width: 500px;
}

.modal-card-foot {
  justify-content: right;
}

.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
