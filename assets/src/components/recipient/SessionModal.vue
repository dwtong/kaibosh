<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" @submit="saveSession">
      <template v-slot:title>{{ isExistingSession ? "Edit " : "Add" }} Sorting Session</template>

      <div class="columns">
        <div class="column">
          <p class="subtitle">Select session time and day</p>
          <SessionSelect v-model="selectedSessionId" :sessions="sessions" required="true" />
          <p v-if="sessionExists" class="error-msg">
            Selected session already exists.
          </p>
        </div>
      </div>

      <div v-if="showCategories" class="columns">
        <div class="column">
          <p class="subtitle">Choose category categories</p>
          <AllocationQuantitiesInput v-model="allocations" :base-id="baseId" />
        </div>
      </div>
    </ModalForm>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IRecipientSession, IAllocation } from "@/types";
import RecipientSessions from "@/store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/recipient/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";
import SessionSelect from "@/components/ui/SessionSelect.vue";
import ModalForm from "@/components/ui/ModalForm.vue";

@Component({ components: { SessionSelect, AllocationQuantitiesInput, ModalForm } })
export default class SessionModal extends Vue {
  @Prop({ required: true }) readonly recipientId!: string;
  @Prop({ required: true }) readonly baseId!: string;
  @Prop({ required: true }) readonly sessions!: IRecipientSession[];
  @Prop() readonly session?: IRecipientSession;
  allocations: IAllocation[] = [];
  selectedSessionId = "";
  isOpen = false;

  async created() {
    if (this.session) {
      this.allocations = this.session.allocations ? [...this.session.allocations] : [];
      this.selectedSessionId = this.session.sessionId ?? "";
    }
  }

  get isExistingSession(): boolean {
    return !!this.session;
  }

  get showCategories(): boolean {
    return this.selectedSessionId !== "" && !this.sessionExists;
  }

  get sessionExists(): boolean {
    return !!this.sessions.find(s => s.sessionId === this.selectedSessionId && s.sessionId !== this.session?.sessionId);
  }

  openModal() {
    this.isOpen = true;
  }

  async saveSession() {
    const params = {
      recipientId: this.recipientId,
      sessionId: this.selectedSessionId,
      allocations: this.allocations
    };

    if (this.session) {
      await RecipientSessions.updateSession({
        ...this.session,
        ...params
      });
    } else {
      await RecipientSessions.createSession(params);
    }

    this.$emit("close");
    this.allocations = [];
    this.selectedSessionId = "";
    toast.success(`Session ${this.isExistingSession ? "updated" : "created"}.`);
  }
}
</script>

<style lang="scss" scoped>
.error-msg {
  font-size: 0.8rem;
  color: red;
}
</style>
