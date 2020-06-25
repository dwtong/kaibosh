<template>
  <b-collapse aria-id="contentIdForA11y3" :open="isOpen" class="session-card">
    <div slot="trigger" aria-controls="contentIdForA11y3" class="level box header">
      <div class="level-left">
        <div class="level-item">
          <p v-if="session.sessionSlot">
            <span class="has-text-weight-semibold is-size-5 day-text">{{ session.sessionSlot.day }} </span>
            <span class="is-size-5">{{ session.sessionSlot.time }}</span>
          </p>
        </div>
      </div>
      <div class="level-item"></div>
      <div class="level-right">
        <div class="level-item">
          <HoldStatusTag :status="session.holdStatus" />
        </div>
      </div>
    </div>
    <div class="box">
      <div class="card-content">
        <div v-if="session.holds && session.holds.length > 0" class="content">
          <p class="label">Session Holds</p>
          <HoldsList :holds="session.holds" :session-id="session.id" />
        </div>

        <div class="content">
          <p class="label">Food Allocations</p>
          <AllocationList :allocations="session.allocations" />
        </div>

        <div class="buttons">
          <SessionModal
            v-slot="{ open }"
            :session="session"
            :base-id="baseId"
            :recipient-id="recipientId"
            :sessions="sessions"
          >
            <a class="button is-primary" @click="open">Edit</a>
          </SessionModal>
          <a class="button is-danger" @click="confirmSessionDeletion">Delete</a>
        </div>
      </div>
    </div>
  </b-collapse>
</template>

<script lang="ts">
import Vue from "vue";
import { Component, Prop } from "vue-property-decorator";
import { IScheduledSession } from "@/types";
import HoldsList from "@/components/recipient/HoldsList.vue";
import AllocationList from "@/components/recipient/AllocationList.vue";
import HoldStatusTag from "@/components/ui/HoldStatusTag.vue";
import RecipientSessions from "@/store/modules/recipient-sessions";
import SessionModal from "@/components/recipient/SessionModal.vue";
import toast from "@/helpers/toast";

@Component({ components: { HoldsList, AllocationList, HoldStatusTag, SessionModal } })
export default class SessionCard extends Vue {
  @Prop({ required: true }) readonly session!: IScheduledSession;
  @Prop({ required: true }) readonly sessions!: IScheduledSession[];
  @Prop() readonly baseId!: string;
  @Prop() readonly recipientId!: string;
  isOpen = false;

  toggleIsOpen() {
    this.isOpen = !this.isOpen;
  }

  confirmSessionDeletion() {
    this.$buefy.dialog.confirm({
      message: "Are you sure you wish to remove this session?",
      type: "is-danger",
      onConfirm: async () => {
        if (this.session.id) {
          await RecipientSessions.deleteSession(this.session.id);
          toast.success("Deleted session.");
        }
      }
    });
  }
}
</script>

<style lang="scss" scoped>
.box {
  border-radius: 0px;
  border-color: black;
  padding: 1rem;
  box-shadow: 0;
}

.buttons {
  margin-top: 2rem;
}

.content {
  margin-bottom: 2.5rem !important;
}

.header {
  background-color: #e6e6e6;
}

.day-text {
  margin-right: 0.5rem;
}

.session-card {
  margin-bottom: 1rem;
}
</style>
