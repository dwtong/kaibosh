<template>
  <div>
    <slot :open="openModal"></slot>
    <ModalForm v-model="isOpen" :loading="loading" @submit="saveSession">
      <template v-slot:title>{{ isExistingSession ? "Edit " : "Add" }} Sorting Session</template>

      <div class="columns">
        <div class="column">
          <p class="subtitle">Select session time and day</p>
          <SessionSelect
            v-model="selectedSessionId"
            :sessions="sessions"
            required="true"
            :disabled="isExistingSession"
          />
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
import { IScheduledSession, IAllocation } from "@/types";
import App from "@/store/modules/app";
import RecipientSessions from "@/store/modules/recipient-sessions";
import AllocationQuantitiesInput from "@/components/recipient/AllocationQuantitiesInput.vue";
import toast from "@/helpers/toast";
import SessionSelect from "@/components/ui/SessionSelect.vue";
import ModalForm from "@/components/ui/ModalForm.vue";
import Sessions from "@/store/modules/session-slots";

@Component({ components: { SessionSelect, AllocationQuantitiesInput, ModalForm } })
export default class SessionModal extends Vue {
  @Prop({ required: true }) readonly recipientId!: string;
  @Prop({ required: true }) readonly baseId!: string;
  @Prop({ required: true }) readonly sessions!: IScheduledSession[];
  @Prop() readonly session?: IScheduledSession;
  allocations: IAllocation[] = [];
  selectedSessionId = "";
  loading = true;
  isOpen = false;

  async created() {
    await Promise.all([App.fetchCategories(this.baseId), Sessions.fetchList(this.baseId)]);

    if (this.session) {
      this.allocations = this.session.allocations ? [...this.session.allocations] : [];
      this.selectedSessionId = this.session.session?.id ?? "";
    }

    this.loading = false;
  }

  get isExistingSession(): boolean {
    return !!this.session;
  }

  get showCategories(): boolean {
    return !this.loading && this.selectedSessionId !== "" && !this.sessionExists;
  }

  get sessionExists(): boolean {
    return !!this.sessions.find(
      s => s.session?.id === this.selectedSessionId && s.session?.id !== this.session?.session?.id
    );
  }

  openModal() {
    this.isOpen = true;
  }

  async saveSession() {
    const params = {
      recipientId: this.recipientId,
      sessionId: this.selectedSessionId,
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
