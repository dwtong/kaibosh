<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" :loading="loading" @submit="saveSession">
      <template v-slot:title>{{ isExistingSession ? "Edit " : "Add" }} Sorting Session</template>

      <div class="columns">
        <div class="column">
          <p class="subtitle">Select session time and day</p>
          <SessionSlotSelect
            v-model="selectedSessionSlotId"
            :sessions="sessions"
            required="true"
            :disabled="isExistingSession"
          />
          <p v-if="sessionExists" class="error-msg">
            Selected session already exists.
          </p>
        </div>
      </div>

      <div v-if="showFoodCategories" class="columns">
        <div class="column">
          <p class="subtitle">Choose food categories</p>
          <AllocationQuantitiesInput v-model="allocations" />
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession, IAllocation } from "@/types";
import RecipientSessions from "@/store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/recipient/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";
import SessionSlotSelect from "@/components/ui/SessionSlotSelect.vue";
import ModalForm from "@/components/ui/ModalForm.vue";
import SessionSlots from "@/store/modules/session-slots";

@Component({ components: { SessionSlotSelect, AllocationQuantitiesInput, ModalForm } })
export default class SessionModal extends Vue {
  @Prop({ required: true }) readonly recipientId!: string;
  @Prop({ required: true }) readonly baseId!: string;
  @Prop({ required: true }) readonly sessions!: IScheduledSession[];
  @Prop() readonly session?: IScheduledSession;
  allocations: IAllocation[] = [];
  selectedSessionSlotId = "";
  loading = true;
  isOpen = false;

  async created() {
    await SessionSlots.fetchList({ baseId: this.baseId });

    if (this.session) {
      this.allocations = this.session.allocations ? [...this.session.allocations] : [];
      this.selectedSessionSlotId = this.session.sessionSlot?.id ?? "";
    }

    this.loading = false;
  }

  get isExistingSession(): boolean {
    return !!this.session;
  }

  get showFoodCategories(): boolean {
    return !this.loading && this.selectedSessionSlotId !== "" && !this.sessionExists;
  }

  get sessionExists(): boolean {
    return !!this.sessions.find(
      s => s.sessionSlot?.id === this.selectedSessionSlotId && s.sessionSlot?.id !== this.session?.sessionSlot?.id
    );
  }

  openModal() {
    this.isOpen = true;
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
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
