<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" :loading="loading" @submit="saveSession">
      <template v-slot:title>Add Sorting Session</template>

      <div class="columns">
        <div class="column">
          <p class="subtitle">Select session time and day</p>
          <SessionSlotSelect v-model="selectedSessionSlotId" :sessions="sessions" required="true" />
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
export default class SessionCreateModal extends Vue {
  @Prop() readonly recipientId!: string;
  @Prop() readonly baseId!: string;
  @Prop() readonly sessions?: IScheduledSession[];
  allocations: IAllocation[] = [];
  selectedSessionSlotId = "";
  session!: IScheduledSession;
  loading = true;
  isOpen = false;

  async created() {
    await SessionSlots.fetchList({ baseId: this.baseId });
    this.loading = false;
  }

  get showFoodCategories(): boolean {
    return !this.loading && this.selectedSessionSlotId !== "" && !this.sessionExists;
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

    await RecipientSessions.createSession(params);
    // TODO: handle failure
    toast.success("Scheduled session created.");
  }

  get sessionExists(): boolean {
    return !!this.sessions?.find(s => s.sessionSlot?.id === this.selectedSessionSlotId);
  }
}
</script>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
